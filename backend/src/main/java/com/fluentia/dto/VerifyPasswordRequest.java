package com.fluentia.dto;

import java.util.UUID;

public record VerifyPasswordRequest(UUID userId, String password) {}
