package com.fluentia.controllers;

import com.fluentia.dto.PlacementQuestionsPayload;
import com.fluentia.dto.PlacementSubmitRequest;
import com.fluentia.dto.PlacementSubmitResponse;
import com.fluentia.services.PlacementService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/placement")
public class PlacementController {

    private final PlacementService placementService;

    public PlacementController(PlacementService placementService) {
        this.placementService = placementService;
    }

    @GetMapping("/questions")
    public PlacementQuestionsPayload questions(@RequestParam(name = "language", defaultValue = "es") String language) {
        return placementService.getQuestions(language);
    }

    @PostMapping("/submit")
    public PlacementSubmitResponse submit(@RequestBody PlacementSubmitRequest body) {
        return placementService.submit(body);
    }
}

