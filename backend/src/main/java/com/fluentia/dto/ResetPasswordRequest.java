package com.fluentia.dto;

public record ResetPasswordRequest(String token, String password) {}
