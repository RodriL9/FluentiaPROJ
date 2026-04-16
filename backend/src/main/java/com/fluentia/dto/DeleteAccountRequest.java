package com.fluentia.dto;

import java.util.UUID;

public record DeleteAccountRequest(UUID userId, String password) {}
