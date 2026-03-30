package com.fluentia.services;

import com.fluentia.config.FluentiaProperties;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.services.gmail.Gmail;
import com.google.api.services.gmail.model.Message;
import com.google.auth.http.HttpCredentialsAdapter;
import com.google.auth.oauth2.UserCredentials;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Properties;

import jakarta.mail.Session;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

@Service
public class GmailMailService {

    private static final Logger log = LoggerFactory.getLogger(GmailMailService.class);

    private final FluentiaProperties props;
    private final NetHttpTransport transport;

    public GmailMailService(FluentiaProperties props, NetHttpTransport transport) {
        this.props = props;
        this.transport = transport;
    }

    public boolean isConfigured() {
        FluentiaProperties.Google g = props.getGoogle();
        return !blank(g.getGmailClientId())
                && !blank(g.getGmailClientSecret())
                && !blank(g.getGmailRefreshToken())
                && !blank(g.getGmailFromEmail());
    }

    public void sendVerificationEmail(String toEmail, String verificationUrl) throws Exception {
        if (!isConfigured()) {
            throw new IllegalStateException("Gmail API credentials are not configured");
        }
        FluentiaProperties.Google g = props.getGoogle();
        String from = g.getGmailFromEmail().trim();
        String subject = "Verify your Fluentia account";
        String text =
                "Welcome to Fluentia.\r\n\r\nOpen this link to verify your email address:\r\n"
                        + verificationUrl
                        + "\r\n\r\nIf you did not create an account, you can ignore this message.\r\n";

        UserCredentials credentials =
                UserCredentials.newBuilder()
                        .setClientId(g.getGmailClientId().trim())
                        .setClientSecret(g.getGmailClientSecret().trim())
                        .setRefreshToken(g.getGmailRefreshToken().trim())
                        .build();

        Gmail gmail =
                new Gmail.Builder(transport, GsonFactory.getDefaultInstance(), new HttpCredentialsAdapter(credentials))
                        .setApplicationName("Fluentia")
                        .build();

        MimeMessage mime = buildMime(from, toEmail, subject, text);
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        mime.writeTo(buffer);
        String encoded =
                Base64.getUrlEncoder().withoutPadding().encodeToString(buffer.toByteArray());

        Message message = new Message();
        message.setRaw(encoded);
        gmail.users().messages().send("me", message).execute();
        log.info("Sent verification email to {}", toEmail);
    }

    private static MimeMessage buildMime(String from, String to, String subject, String body) throws Exception {
        Properties p = new Properties();
        Session session = Session.getDefaultInstance(p, null);
        MimeMessage mime = new MimeMessage(session);
        mime.setFrom(new InternetAddress(from));
        mime.addRecipient(jakarta.mail.Message.RecipientType.TO, new InternetAddress(to));
        mime.setSubject(subject, StandardCharsets.UTF_8.name());
        mime.setText(body, StandardCharsets.UTF_8.name());
        return mime;
    }

    private static boolean blank(String s) {
        return s == null || s.isBlank();
    }
}
