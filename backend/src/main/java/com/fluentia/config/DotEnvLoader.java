package com.fluentia.config;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public final class DotEnvLoader {
    private DotEnvLoader() {}

    public static void load() {
        Path fromCwd = Path.of(System.getProperty("user.dir", "."), ".env");
        if (Files.exists(fromCwd)) {
            loadFile(fromCwd);
            return;
        }
        Path fromBackend = Path.of(System.getProperty("user.dir", "."), "backend", ".env");
        if (Files.exists(fromBackend)) {
            loadFile(fromBackend);
        }
    }

    private static void loadFile(Path path) {
        try {
            List<String> lines = Files.readAllLines(path);
            for (String line : lines) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("#") || !trimmed.contains("=")) {
                    continue;
                }
                int idx = trimmed.indexOf('=');
                String key = trimmed.substring(0, idx).trim();
                String value = unquote(trimmed.substring(idx + 1).trim());
                if (System.getProperty(key) == null && System.getenv(key) == null) {
                    System.setProperty(key, value);
                }
            }
        } catch (IOException ignored) {
        }
    }

    private static String unquote(String value) {
        if (value.length() >= 2) {
            char a = value.charAt(0);
            char b = value.charAt(value.length() - 1);
            if ((a == '"' && b == '"') || (a == '\'' && b == '\'')) {
                return value.substring(1, value.length() - 1);
            }
        }
        return value;
    }
}
