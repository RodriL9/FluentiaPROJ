package com.fluentia.controllers;

import com.fluentia.dto.AuthUserResponse;
import com.fluentia.dto.UpdateTopicRequest;
import com.fluentia.dto.UpdateLanguagesRequest;
import com.fluentia.models.User;
import com.fluentia.repositories.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserRepository userRepository;

    public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @PatchMapping("/{id}/languages")
    public AuthUserResponse updateLanguages(@PathVariable("id") UUID id, @RequestBody UpdateLanguagesRequest body) {
        User user =
                userRepository
                        .findById(id)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        String nativeLang = safe(body.nativeLanguage());
        String learningLang = safe(body.learningLanguage());
        if (nativeLang.isEmpty() || learningLang.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Both languages are required.");
        }

        user.setNativeLanguage(nativeLang);
        user.setLearningLanguage(learningLang);
        user.setUpdatedAt(Instant.now());
        // Keep onboardingCompleted false for now; will be set true after placement/topic.
        userRepository.save(user);

        return new AuthUserResponse(
                user.getId(),
                user.getEmail(),
                user.getUsername(),
                user.getFullName(),
                Boolean.TRUE.equals(user.getIsVerified()),
                user.getNativeLanguage(),
                user.getLearningLanguage(),
                user.getAssignedLevel(),
                user.getOnboardingCompleted(),
                user.getLearningGoals());
    }

    @PatchMapping("/{id}/topic")
    public AuthUserResponse updateTopic(@PathVariable("id") UUID id, @RequestBody UpdateTopicRequest body) {
        User user =
                userRepository
                        .findById(id)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        List<String> cleaned = normalizeTopics(body.topics());
        if (cleaned.size() < 2) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Select at least two topics.");
        }

        user.setLearningGoals(String.join(",", cleaned));
        user.setOnboardingCompleted(true);
        user.setUpdatedAt(Instant.now());
        userRepository.save(user);

        return new AuthUserResponse(
                user.getId(),
                user.getEmail(),
                user.getUsername(),
                user.getFullName(),
                Boolean.TRUE.equals(user.getIsVerified()),
                user.getNativeLanguage(),
                user.getLearningLanguage(),
                user.getAssignedLevel(),
                user.getOnboardingCompleted(),
                user.getLearningGoals());
    }

    public record UpdateLevelRequest(String assignedLevel, String reason) {}

    @PatchMapping("/{id}/level")
    public AuthUserResponse updateLevel(@PathVariable("id") UUID id, @RequestBody UpdateLevelRequest body) {
        User user =
                userRepository
                        .findById(id)
                        .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        String level = safe(body.assignedLevel()).toUpperCase();
        if (level.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "assignedLevel is required.");
        }
        user.setAssignedLevel(level);
        user.setUpdatedAt(Instant.now());
        userRepository.save(user);

        return new AuthUserResponse(
                user.getId(),
                user.getEmail(),
                user.getUsername(),
                user.getFullName(),
                Boolean.TRUE.equals(user.getIsVerified()),
                user.getNativeLanguage(),
                user.getLearningLanguage(),
                user.getAssignedLevel(),
                user.getOnboardingCompleted(),
                user.getLearningGoals());
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static List<String> normalizeTopics(List<String> topics) {
        if (topics == null || topics.isEmpty()) {
            return List.of();
        }
        LinkedHashSet<String> seen = new LinkedHashSet<>();
        for (String t : topics) {
            String s = safe(t);
            if (!s.isEmpty()) {
                seen.add(s);
            }
        }
        return new ArrayList<>(seen);
    }
}

