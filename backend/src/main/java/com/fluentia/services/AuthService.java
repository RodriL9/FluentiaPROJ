package com.fluentia.services;

import com.fluentia.config.FluentiaProperties;
import com.fluentia.dto.AuthUserResponse;
import com.fluentia.dto.DeleteAccountRequest;
import com.fluentia.dto.ForgotPasswordRequest;
import com.fluentia.dto.LoginRequest;
import com.fluentia.dto.RegisterRequest;
import com.fluentia.dto.RegisterResponse;
import com.fluentia.dto.ResetPasswordRequest;
import com.fluentia.dto.VerifyPasswordRequest;
import com.fluentia.models.User;
import com.fluentia.repositories.UserRepository;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);
    private static final int MIN_PASSWORD_LEN = 8;

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final FluentiaProperties props;
    private final GmailMailService gmailMailService;
    private final GoogleIdTokenVerificationService googleIdTokenVerificationService;

    public AuthService(
            UserRepository userRepository,
            PasswordEncoder passwordEncoder,
            FluentiaProperties props,
            GmailMailService gmailMailService,
            GoogleIdTokenVerificationService googleIdTokenVerificationService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.props = props;
        this.gmailMailService = gmailMailService;
        this.googleIdTokenVerificationService = googleIdTokenVerificationService;
    }

    @Transactional
    public RegisterResponse register(RegisterRequest req) {
        String fullName = trim(req.fullName());
        String username = trim(req.username());
        String email = normalizeEmail(req.email());
        String password = req.password() != null ? req.password() : "";

        if (fullName.isEmpty() || username.isEmpty() || email.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Full name, username, and email are required.");
        }
        if (password.length() < MIN_PASSWORD_LEN) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Password must be at least " + MIN_PASSWORD_LEN + " characters.");
        }
        if (!email.contains("@")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Enter a valid email address.");
        }

        if (userRepository.findByEmailIgnoreCase(email).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "An account with this email already exists.");
        }
        if (userRepository.findByUsernameIgnoreCase(username).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "This username is already taken.");
        }

        Instant now = Instant.now();
        User user = new User();
        user.setFullName(fullName);
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordEncoder.encode(password));
        // DB requires non-null languages. Use same placeholder values so onboarding
        // can still detect "not chosen yet" and ask the language step first.
        user.setNativeLanguage("en");
        user.setLearningLanguage("en");
        user.setRole("LEARNER");
        user.setIsPremium(false);
        user.setXp(0);
        user.setStreakCount(0);
        user.setLoginCount(0);
        user.setOnboardingCompleted(false);
        user.setIsActive(true);
        user.setJoinedAt(now);
        user.setUpdatedAt(now);

        if (props.getApp().isSkipEmailVerification()) {
            user.setAccountStatus("ACTIVE");
            user.setIsVerified(true);
            user.setEmailVerificationToken(null);
            userRepository.save(user);
            return new RegisterResponse(
                    user.getId(),
                    user.getEmail(),
                    user.getUsername(),
                    user.getFullName(),
                    true,
                    false);
        }

        if (!gmailMailService.isConfigured()) {
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Email verification is enabled but Gmail API is not configured. Add GMAIL_OAUTH_CLIENT_ID, "
                            + "GMAIL_OAUTH_CLIENT_SECRET, GMAIL_OAUTH_REFRESH_TOKEN, and GMAIL_FROM_EMAIL to .env "
                            + "(or set SKIP_EMAIL_VERIFICATION=true for local development).");
        }

        String token = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
        user.setEmailVerificationToken(token);
        user.setAccountStatus("PENDING_VERIFICATION");
        user.setIsVerified(false);
        userRepository.save(user);

        String verifyLink = buildVerifyLink(token);
        try {
            gmailMailService.sendVerificationEmail(user.getEmail(), verifyLink);
        } catch (Exception e) {
            log.error("Failed to send verification email", e);
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR, "Could not send verification email. Try again later.");
        }

        return new RegisterResponse(
                user.getId(), user.getEmail(), user.getUsername(), user.getFullName(), false, true);
    }

    private String buildVerifyLink(String token) {
        String base = props.getApp().getApiPublicBaseUrl().trim().replaceAll("/$", "");
        return base + "/auth/verify-email?token=" + URLEncoder.encode(token, StandardCharsets.UTF_8);
    }

    private String buildResetPasswordLink(String token) {
        String base = props.getApp().getFrontendPublicUrl().trim().replaceAll("/$", "");
        return base + "/reset-password?token=" + URLEncoder.encode(token, StandardCharsets.UTF_8);
    }

    @Transactional
    public void forgotPassword(ForgotPasswordRequest req) {
        String email = normalizeEmail(req != null ? req.email() : null);
        if (email.isEmpty() || !email.contains("@")) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Enter a valid email address.");
        }
        if (!gmailMailService.isConfigured()) {
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Password reset email is not configured. Add GMAIL_OAUTH_CLIENT_ID, "
                            + "GMAIL_OAUTH_CLIENT_SECRET, GMAIL_OAUTH_REFRESH_TOKEN, and GMAIL_FROM_EMAIL to .env.");
        }

        Optional<User> maybe = userRepository.findByEmailIgnoreCase(email);
        if (maybe.isEmpty()) return;

        User user = maybe.get();
        String token = UUID.randomUUID().toString().replace("-", "") + UUID.randomUUID().toString().replace("-", "");
        user.setPasswordResetToken(token);
        user.setPasswordResetExpires(Instant.now().plus(30, ChronoUnit.MINUTES));
        user.setUpdatedAt(Instant.now());
        userRepository.save(user);

        String resetLink = buildResetPasswordLink(token);
        try {
            gmailMailService.sendPasswordResetEmail(user.getEmail(), resetLink);
        } catch (Exception e) {
            log.error("Failed to send password reset email", e);
            throw new ResponseStatusException(
                    HttpStatus.INTERNAL_SERVER_ERROR, "Could not send password reset email. Try again later.");
        }
    }

    @Transactional
    public void resetPassword(ResetPasswordRequest req) {
        String token = req != null ? trim(req.token()) : "";
        String password = req != null && req.password() != null ? req.password() : "";
        if (token.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Missing reset token.");
        }
        if (password.length() < MIN_PASSWORD_LEN) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Password must be at least " + MIN_PASSWORD_LEN + " characters.");
        }

        User user =
                userRepository
                        .findByPasswordResetToken(token)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid reset link."));

        Instant expiresAt = user.getPasswordResetExpires();
        if (expiresAt == null || Instant.now().isAfter(expiresAt)) {
            throw new ResponseStatusException(HttpStatus.GONE, "This reset link has expired. Request a new one.");
        }

        user.setPasswordHash(passwordEncoder.encode(password));
        user.setPasswordResetToken(null);
        user.setPasswordResetExpires(null);
        user.setUpdatedAt(Instant.now());
        userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public void verifyPassword(VerifyPasswordRequest req) {
        if (req == null || req.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is required.");
        }
        String password = req.password() != null ? req.password() : "";
        if (password.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password is required.");
        }
        User user =
                userRepository
                        .findById(req.userId())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found."));
        if (user.getPasswordHash() == null || user.getPasswordHash().isBlank()) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "This account does not use a password login. Sign in with your provider and contact support for deletion.");
        }
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Incorrect password.");
        }
    }

    @Transactional
    public void deleteAccount(DeleteAccountRequest req) {
        if (req == null || req.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is required.");
        }
        String password = req.password() != null ? req.password() : "";
        if (password.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password is required to delete your account.");
        }

        User user =
                userRepository
                        .findById(req.userId())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found."));

        if (user.getPasswordHash() == null || user.getPasswordHash().isBlank()) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "This account does not use a password login. Sign in with your provider and contact support for deletion.");
        }
        if (!passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Incorrect password.");
        }

        try {
            userRepository.delete(user);
            userRepository.flush();
        } catch (DataIntegrityViolationException e) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Could not delete account due to related records. Please contact support.",
                    e);
        }
    }

    @Transactional
    public void verifyEmail(String token) {
        if (token == null || token.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid verification link.");
        }
        User user =
                userRepository
                        .findByEmailVerificationToken(token.trim())
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid verification link."));

        Instant joined = user.getJoinedAt() != null ? user.getJoinedAt() : Instant.EPOCH;
        if (Instant.now().isAfter(joined.plus(48, ChronoUnit.HOURS))) {
            throw new ResponseStatusException(HttpStatus.GONE, "This verification link has expired. Register again or request a new email.");
        }

        user.setIsVerified(true);
        user.setAccountStatus("ACTIVE");
        user.setEmailVerificationToken(null);
        user.setEmailVerifiedAt(Instant.now());
        user.setUpdatedAt(Instant.now());
        userRepository.save(user);
    }

    @Transactional
    public AuthUserResponse login(LoginRequest req) {
        String email = normalizeEmail(req.email());
        String password = req.password() != null ? req.password() : "";

        if (email.isEmpty() || password.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Email and password are required.");
        }

        User user =
                userRepository
                        .findByEmailIgnoreCase(email)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password."));

        if (user.getPasswordHash() == null || !passwordEncoder.matches(password, user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password.");
        }

        if (Boolean.FALSE.equals(user.getIsActive())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "This account is inactive.");
        }

        if (!Boolean.TRUE.equals(user.getIsVerified()) || "PENDING_VERIFICATION".equals(user.getAccountStatus())) {
            throw new ResponseStatusException(
                    HttpStatus.FORBIDDEN,
                    "Please verify your email before signing in. Check your inbox for the verification link.");
        }

        return finishPasswordOrLinkedLogin(user);
    }

    @Transactional
    public AuthUserResponse loginWithGoogle(String idToken) {
        if (idToken == null || idToken.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Missing Google credential.");
        }
        if (props.getGoogle().getWebClientId() == null || props.getGoogle().getWebClientId().isBlank()) {
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE, "Google sign-in is not configured (set GOOGLE_WEB_CLIENT_ID in .env).");
        }

        Optional<GoogleIdToken.Payload> verified = googleIdTokenVerificationService.verify(idToken);
        if (verified.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid Google sign-in. Try again.");
        }

        GoogleIdToken.Payload payload = verified.get();
        Object emailVerifiedObj = payload.get("email_verified");
        boolean emailVerified =
                Boolean.TRUE.equals(emailVerifiedObj) || "true".equalsIgnoreCase(String.valueOf(emailVerifiedObj));
        if (!emailVerified) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Your Google account email is not verified.");
        }

        String email = payload.getEmail();
        String sub = payload.getSubject();
        String name = (String) payload.get("name");
        if (email == null || sub == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid Google sign-in.");
        }
        email = normalizeEmail(email);

        Optional<User> byOauth = userRepository.findByOauthProviderAndOauthId("google", sub);
        if (byOauth.isPresent()) {
            return finishPasswordOrLinkedLogin(byOauth.get());
        }

        Optional<User> byEmail = userRepository.findByEmailIgnoreCase(email);
        if (byEmail.isPresent()) {
            User u = byEmail.get();
            if (u.getOauthId() != null && !u.getOauthId().equals(sub)) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "This email is already linked to another account.");
            }
            u.setOauthProvider("google");
            u.setOauthId(sub);
            u.setIsVerified(true);
            u.setAccountStatus("ACTIVE");
            if ((u.getFullName() == null || u.getFullName().isBlank()) && name != null && !name.isBlank()) {
                u.setFullName(name);
            }
            userRepository.save(u);
            return finishPasswordOrLinkedLogin(u);
        }

        Instant now = Instant.now();
        User u = new User();
        u.setEmail(email);
        u.setUsername(uniqueUsernameFromLocalPart(email));
        u.setFullName(name != null && !name.isBlank() ? name : u.getUsername());
        u.setPasswordHash(null);
        u.setOauthProvider("google");
        u.setOauthId(sub);
        // DB requires non-null languages. Use same placeholder values so onboarding
        // can still detect "not chosen yet" and ask the language step first.
        u.setNativeLanguage("en");
        u.setLearningLanguage("en");
        u.setRole("LEARNER");
        u.setIsVerified(true);
        u.setAccountStatus("ACTIVE");
        u.setIsPremium(false);
        u.setXp(0);
        u.setStreakCount(0);
        u.setLoginCount(0);
        u.setOnboardingCompleted(false);
        u.setIsActive(true);
        u.setJoinedAt(now);
        u.setUpdatedAt(now);
        userRepository.save(u);
        return finishPasswordOrLinkedLogin(u);
    }

    private AuthUserResponse finishPasswordOrLinkedLogin(User user) {
        if (Boolean.FALSE.equals(user.getIsActive())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "This account is inactive.");
        }
        Instant now = Instant.now();
        user.setLastLoginAt(now);
        user.setUpdatedAt(now);
        int count = user.getLoginCount() != null ? user.getLoginCount() : 0;
        user.setLoginCount(count + 1);
        userRepository.save(user);
        return new AuthUserResponse(
                user.getId(),
                user.getEmail(),
                user.getUsername(),
                user.getFullName(),
                Boolean.TRUE.equals(user.getIsVerified()),
                user.getNativeLanguage(),
                user.getLearningLanguage(),
                user.getAssignedLevel(),
                user.getOnboardingCompleted(),
                user.getLearningGoals());
    }

    private String uniqueUsernameFromLocalPart(String email) {
        int at = email.indexOf('@');
        String local = at > 0 ? email.substring(0, at) : email;
        local = local.replaceAll("[^a-zA-Z0-9_]", "");
        if (local.length() < 2) {
            local = "learner";
        }
        if (local.length() > 40) {
            local = local.substring(0, 40);
        }
        String candidate = local;
        int n = 0;
        while (userRepository.findByUsernameIgnoreCase(candidate).isPresent()) {
            n++;
            candidate = local + "_" + n;
            if (candidate.length() > 50) {
                candidate = local.substring(0, Math.min(30, local.length())) + "_" + UUID.randomUUID().toString().substring(0, 8);
            }
        }
        return candidate;
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private static String normalizeEmail(String email) {
        return trim(email).toLowerCase();
    }
}
