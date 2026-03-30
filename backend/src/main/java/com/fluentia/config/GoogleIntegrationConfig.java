package com.fluentia.config;

import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.IOException;
import java.security.GeneralSecurityException;

@Configuration
public class GoogleIntegrationConfig {

    @Bean
    public NetHttpTransport googleNetHttpTransport() throws GeneralSecurityException, IOException {
        return GoogleNetHttpTransport.newTrustedTransport();
    }
}
