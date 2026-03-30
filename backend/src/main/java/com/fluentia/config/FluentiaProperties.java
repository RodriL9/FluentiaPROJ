package com.fluentia.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "fluentia")
public class FluentiaProperties {

    private App app = new App();
    private Google google = new Google();

    public App getApp() {
        return app;
    }

    public void setApp(App app) {
        this.app = app;
    }

    public Google getGoogle() {
        return google;
    }

    public void setGoogle(Google google) {
        this.google = google;
    }

    public static class App {
        private String frontendPublicUrl = "http://localhost:5173";
        private String apiPublicBaseUrl = "http://localhost:8080/api";
        private boolean skipEmailVerification = false;

        public String getFrontendPublicUrl() {
            return frontendPublicUrl;
        }

        public void setFrontendPublicUrl(String frontendPublicUrl) {
            this.frontendPublicUrl = frontendPublicUrl;
        }

        public String getApiPublicBaseUrl() {
            return apiPublicBaseUrl;
        }

        public void setApiPublicBaseUrl(String apiPublicBaseUrl) {
            this.apiPublicBaseUrl = apiPublicBaseUrl;
        }

        public boolean isSkipEmailVerification() {
            return skipEmailVerification;
        }

        public void setSkipEmailVerification(boolean skipEmailVerification) {
            this.skipEmailVerification = skipEmailVerification;
        }
    }

    public static class Google {
        private String webClientId = "";
        private String gmailClientId = "";
        private String gmailClientSecret = "";
        private String gmailRefreshToken = "";
        private String gmailFromEmail = "";

        public String getWebClientId() {
            return webClientId;
        }

        public void setWebClientId(String webClientId) {
            this.webClientId = webClientId;
        }

        public String getGmailClientId() {
            return gmailClientId;
        }

        public void setGmailClientId(String gmailClientId) {
            this.gmailClientId = gmailClientId;
        }

        public String getGmailClientSecret() {
            return gmailClientSecret;
        }

        public void setGmailClientSecret(String gmailClientSecret) {
            this.gmailClientSecret = gmailClientSecret;
        }

        public String getGmailRefreshToken() {
            return gmailRefreshToken;
        }

        public void setGmailRefreshToken(String gmailRefreshToken) {
            this.gmailRefreshToken = gmailRefreshToken;
        }

        public String getGmailFromEmail() {
            return gmailFromEmail;
        }

        public void setGmailFromEmail(String gmailFromEmail) {
            this.gmailFromEmail = gmailFromEmail;
        }
    }
}
