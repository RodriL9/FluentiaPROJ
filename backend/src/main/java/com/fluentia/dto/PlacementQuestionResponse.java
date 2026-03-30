package com.fluentia.dto;

import com.fasterxml.jackson.databind.JsonNode;

import java.util.UUID;

public record PlacementQuestionResponse(
        UUID id,
        Integer questionIndex,
        String questionType,
        String prompt,
        JsonNode options,
        String difficulty,
        String skillTested,
        Integer pointsValue,
        Integer timeLimitSeconds) {}

