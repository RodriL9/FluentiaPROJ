package com.fluentia.dto;

import java.util.UUID;

public record AuthUserResponse(
        UUID id,
        String email,
        String username,
        String fullName,
        boolean emailVerified,
        String nativeLanguage,
        String learningLanguage,
        String assignedLevel,
        Boolean onboardingCompleted,
        String learningGoals) {}
