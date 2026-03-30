package com.fluentia.dto;

import java.util.UUID;

public record RegisterResponse(
        UUID id,
        String email,
        String username,
        String fullName,
        boolean emailVerified,
        boolean verificationEmailSent) {}
