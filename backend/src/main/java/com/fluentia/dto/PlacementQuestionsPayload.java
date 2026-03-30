package com.fluentia.dto;

import java.util.List;

public record PlacementQuestionsPayload(String language, List<PlacementQuestionResponse> questions) {}

