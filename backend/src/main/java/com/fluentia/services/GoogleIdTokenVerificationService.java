package com.fluentia.services;

import com.fluentia.config.FluentiaProperties;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Optional;

@Service
public class GoogleIdTokenVerificationService {

    private final FluentiaProperties props;
    private final NetHttpTransport transport;

    public GoogleIdTokenVerificationService(FluentiaProperties props, NetHttpTransport transport) {
        this.props = props;
        this.transport = transport;
    }

    public Optional<GoogleIdToken.Payload> verify(String idTokenString) {
        String clientId = props.getGoogle().getWebClientId();
        if (clientId == null || clientId.isBlank() || idTokenString == null || idTokenString.isBlank()) {
            return Optional.empty();
        }
        try {
            GoogleIdTokenVerifier verifier =
                    new GoogleIdTokenVerifier.Builder(transport, GsonFactory.getDefaultInstance())
                            .setAudience(Collections.singletonList(clientId.trim()))
                            .build();
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                return Optional.empty();
            }
            return Optional.of(idToken.getPayload());
        } catch (Exception e) {
            return Optional.empty();
        }
    }
}
