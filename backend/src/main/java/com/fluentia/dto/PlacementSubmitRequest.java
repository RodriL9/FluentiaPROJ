package com.fluentia.dto;

import java.util.List;
import java.util.UUID;

public record PlacementSubmitRequest(
        UUID userId, String language, Integer durationSeconds, List<PlacementAnswerSubmission> answers) {}

