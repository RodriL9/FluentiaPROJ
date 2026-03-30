package com.fluentia.services;

import com.fluentia.dto.*;
import com.fluentia.models.PlacementAnswer;
import com.fluentia.models.PlacementQuestion;
import com.fluentia.models.PlacementTest;
import com.fluentia.models.User;
import com.fluentia.repositories.PlacementAnswerRepository;
import com.fluentia.repositories.PlacementQuestionRepository;
import com.fluentia.repositories.PlacementTestRepository;
import com.fluentia.repositories.UserRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PlacementService {

    private final PlacementQuestionRepository placementQuestionRepository;
    private final PlacementTestRepository placementTestRepository;
    private final PlacementAnswerRepository placementAnswerRepository;
    private final UserRepository userRepository;

    public PlacementService(
            PlacementQuestionRepository placementQuestionRepository,
            PlacementTestRepository placementTestRepository,
            PlacementAnswerRepository placementAnswerRepository,
            UserRepository userRepository) {
        this.placementQuestionRepository = placementQuestionRepository;
        this.placementTestRepository = placementTestRepository;
        this.placementAnswerRepository = placementAnswerRepository;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public PlacementQuestionsPayload getQuestions(String language) {
        String lang = normalizeLang(language);
        List<PlacementQuestion> questions = placementQuestionRepository.findTop10ByLanguageOrderByQuestionIndexAsc(lang);
        List<PlacementQuestionResponse> out = questions.stream()
                .map(q -> new PlacementQuestionResponse(
                        q.getId(),
                        q.getQuestionIndex(),
                        q.getQuestionType(),
                        q.getPrompt(),
                        q.getOptions(),
                        q.getDifficulty(),
                        q.getSkillTested(),
                        q.getPointsValue(),
                        q.getTimeLimitSeconds()))
                .toList();
        return new PlacementQuestionsPayload(lang, out);
    }

    @Transactional
    public PlacementSubmitResponse submit(PlacementSubmitRequest req) {
        if (req == null || req.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User is required.");
        }
        String lang = normalizeLang(req.language());
        User user = userRepository.findById(req.userId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found."));

        List<PlacementQuestion> testQuestions = placementQuestionRepository.findTop10ByLanguageOrderByQuestionIndexAsc(lang);
        if (testQuestions.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No placement questions found for language: " + lang);
        }
        Map<UUID, String> answerMap = Optional.ofNullable(req.answers()).orElse(List.of()).stream()
                .filter(a -> a != null && a.questionId() != null)
                .collect(Collectors.toMap(PlacementAnswerSubmission::questionId, a -> safe(a.answer()), (a, b) -> b));

        int score = 0;
        List<PlacementAnswer> answerRows = new ArrayList<>();
        for (PlacementQuestion q : testQuestions) {
            String userAnswer = safe(answerMap.get(q.getId()));
            String correct = safe(q.getCorrectAnswer());
            boolean correctFlag = equalsLoose(userAnswer, correct);
            if (correctFlag) {
                score += q.getPointsValue() != null ? q.getPointsValue() : 1;
            }

            PlacementAnswer pa = new PlacementAnswer();
            pa.setTestId(null); // set after test persists
            pa.setQuestionIndex(q.getQuestionIndex());
            pa.setQuestionType(q.getQuestionType());
            pa.setUserAnswer(userAnswer);
            pa.setCorrectAnswer(correct);
            pa.setIsCorrect(correctFlag);
            answerRows.add(pa);
        }

        int total = testQuestions.stream().map(q -> q.getPointsValue() != null ? q.getPointsValue() : 1).reduce(0, Integer::sum);
        if (total <= 0) total = testQuestions.size();
        double percentDouble = (score * 100.0) / total;
        BigDecimal percent = BigDecimal.valueOf(percentDouble).setScale(2, RoundingMode.HALF_UP);
        String level = assignLevel(percentDouble);

        PlacementTest test = new PlacementTest();
        test.setUserId(user.getId());
        test.setLanguage(lang);
        test.setScore(score);
        test.setTotalQuestions(total);
        test.setPercentageScore(percent);
        test.setAssignedLevel(level);
        test.setDurationSeconds(req.durationSeconds() != null ? req.durationSeconds() : 0);
        test.setWasCompleted(true);
        test.setTakenAt(Instant.now());
        placementTestRepository.save(test);

        UUID testId = test.getId();
        for (PlacementAnswer pa : answerRows) {
            pa.setTestId(testId);
        }
        placementAnswerRepository.saveAll(answerRows);

        user.setAssignedLevel(level);
        user.setLearningLanguage(lang);
        user.setOnboardingCompleted(false);
        userRepository.save(user);

        return new PlacementSubmitResponse(score, total, percent.doubleValue(), level);
    }

    private static String assignLevel(double pct) {
        if (pct < 40) return "BEGINNER";
        if (pct < 65) return "INTERMEDIATE";
        if (pct < 85) return "UPPER_INTERMEDIATE";
        return "ADVANCED";
    }

    private static String normalizeLang(String s) {
        String v = safe(s).toLowerCase(Locale.ROOT);
        return v.isEmpty() ? "es" : v;
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static boolean equalsLoose(String a, String b) {
        String aa = normalizeForCompare(a);
        String bb = normalizeForCompare(b);
        return !aa.isEmpty() && aa.equals(bb);
    }

    private static String normalizeForCompare(String s) {
        return safe(s)
                .toLowerCase(Locale.ROOT)
                .replaceAll("[\\p{Punct}]+", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }
}

