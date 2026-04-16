package com.fluentia.controllers;

import com.fluentia.config.FluentiaProperties;
import com.fluentia.dto.AuthUserResponse;
import com.fluentia.dto.DeleteAccountRequest;
import com.fluentia.dto.ForgotPasswordRequest;
import com.fluentia.dto.GoogleLoginRequest;
import com.fluentia.dto.LoginRequest;
import com.fluentia.dto.PublicAuthConfigResponse;
import com.fluentia.dto.RegisterRequest;
import com.fluentia.dto.RegisterResponse;
import com.fluentia.dto.ResetPasswordRequest;
import com.fluentia.dto.VerifyPasswordRequest;
import com.fluentia.services.AuthService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;
    private final FluentiaProperties props;

    public AuthController(AuthService authService, FluentiaProperties props) {
        this.authService = authService;
        this.props = props;
    }

    @GetMapping("/public-config")
    public PublicAuthConfigResponse publicConfig() {
        String id = props.getGoogle().getWebClientId();
        String out = id != null && !id.isBlank() ? id.trim() : "";
        return new PublicAuthConfigResponse(out);
    }

    @PostMapping("/register")
    public RegisterResponse register(@RequestBody RegisterRequest body) {
        return authService.register(body);
    }

    @PostMapping("/login")
    public AuthUserResponse login(@RequestBody LoginRequest body) {
        return authService.login(body);
    }

    @PostMapping("/google")
    public AuthUserResponse google(@RequestBody GoogleLoginRequest body) {
        return authService.loginWithGoogle(body != null ? body.idToken() : null);
    }

    @GetMapping("/verify-email")
    public void verifyEmail(@RequestParam(name = "token", required = false) String token, HttpServletResponse response)
            throws IOException {
        String frontend = props.getApp().getFrontendPublicUrl().trim().replaceAll("/$", "");
        try {
            authService.verifyEmail(token);
            response.sendRedirect(frontend + "/login?verified=1");
        } catch (ResponseStatusException e) {
            response.sendRedirect(frontend + "/login?verified=0");
        } catch (Exception e) {
            response.sendRedirect(frontend + "/login?verified=0");
        }
    }

    @PostMapping("/forgot-password")
    public void forgotPassword(@RequestBody ForgotPasswordRequest body) {
        authService.forgotPassword(body);
    }

    @PostMapping("/reset-password")
    public void resetPassword(@RequestBody ResetPasswordRequest body) {
        authService.resetPassword(body);
    }

    @PostMapping("/delete-account")
    public void deleteAccount(@RequestBody DeleteAccountRequest body) {
        authService.deleteAccount(body);
    }

    @PostMapping("/verify-password")
    public void verifyPassword(@RequestBody VerifyPasswordRequest body) {
        authService.verifyPassword(body);
    }
}
