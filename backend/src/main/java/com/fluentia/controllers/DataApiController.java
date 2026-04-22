package com.fluentia.controllers;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fluentia.config.JdbcJsonNormalizer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Instant;
import java.time.LocalDate;
import java.sql.Timestamp;
import java.util.Locale;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.springframework.http.HttpStatus;

@RestController
public class DataApiController {
    private final JdbcTemplate jdbcTemplate;
    private final JdbcJsonNormalizer jdbcJson;
    private static final ObjectMapper JSON = new ObjectMapper();
    private static final List<String> INAPPROPRIATE_PATTERNS = Arrays.asList(
            "sexual", "sex", "porn", "nude", "naked", "explicit",
            "racist", "hate speech", "slur",
            "kill", "murder", "bomb", "weapon", "suicide", "self harm",
            "drugs", "cocaine", "meth", "heroin",
            "hack", "steal", "fraud", "scam",
            "minor", "child porn"
    );

    public DataApiController(JdbcTemplate jdbcTemplate, JdbcJsonNormalizer jdbcJson) {
        this.jdbcTemplate = jdbcTemplate;
        this.jdbcJson = jdbcJson;
    }

    private List<Map<String, Object>> ql(String sql, Object... args) {
        List<Map<String, Object>> rows = jdbcTemplate.queryForList(sql, args);
        jdbcJson.normalizeRows(rows);
        return rows;
    }

    private Map<String, Object> qm(String sql, Object... args) {
        Map<String, Object> row = jdbcTemplate.queryForMap(sql, args);
        jdbcJson.normalizeRow(row);
        return row;
    }

    private UserContentProfile userContentProfile(UUID userId) {
        if (userId == null) return null;
        Map<String, Object> row = qm("""
                SELECT learning_language, assigned_level, learning_goals
                FROM users
                WHERE id = ?
                """, userId);
        String language = normalizeString(row.get("learning_language"));
        String level = normalizeLevel(row.get("assigned_level"));
        String goals = normalizeGoals(row.get("learning_goals"));
        return new UserContentProfile(language, level, goals);
    }

    private static String normalizeString(Object value) {
        if (value == null) return "";
        return String.valueOf(value).trim();
    }

    private static String normalizeLevel(Object value) {
        String s = normalizeString(value);
        return s.isEmpty() ? "" : s.toUpperCase();
    }

    private static String normalizeGoals(Object value) {
        String s = normalizeString(value);
        if (s.isEmpty()) return "";
        return String.join(",", List.of(s.split(",")).stream().map(String::trim).filter(x -> !x.isEmpty()).toList());
    }

    private record UserContentProfile(String language, String level, String goalsCsv) {
    }

    public record PracticeAttemptRequest(
            UUID userId,
            String language,
            String section,
            Boolean correct,
            Integer durationSeconds,
            String source,
            String topicTag,
            UUID contentId,
            String contentKind,
            String labelSnapshot) {
    }

    public record SubscriptionActionRequest(
            UUID userId,
            String plan,
            Boolean autoRenew,
            String cancelReason) {
    }

    public record AiConversationRequest(
            UUID userId,
            String language,
            String userMessage,
            String mode) {
    }

    @GetMapping("/content-overview")
    public Map<String, Object> contentOverview(@RequestParam(name = "language", defaultValue = "es") String language) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("sections", count("sections", "language", language));
        out.put("units", countUnitsByLanguage(language));
        out.put("lessons", countLessonsByLanguage(language));
        out.put("exercises", countExercisesByLanguage(language));
        out.put("vocabulary", count("vocabulary", "language", language));
        out.put("grammar_rules", count("grammar_rules", "language", language));
        out.put("reading_passages", count("reading_passages", "language", language));
        out.put("phrases", count("phrases", "language", language));
        out.put("topics", count("topics", "language", language));
        out.put("ai_templates", count("ai_conversation_templates", "language", language));
        return out;
    }

    @GetMapping("/dashboard")
    public Map<String, Object> dashboard(@RequestParam(name = "userId", required = false) UUID userId,
                                         @RequestParam(name = "language", defaultValue = "es") String language) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("sections", ql("SELECT id, title, level, display_order FROM sections WHERE language = ? ORDER BY display_order", language));
        out.put("recommendedLessons", userId == null ? List.of() : ql("""
                SELECT lesson_id, reason, priority, is_completed
                FROM personalized_lesson_queue
                WHERE user_id = ?
                ORDER BY priority DESC, lesson_id
                LIMIT 8
                """, userId));
        out.put("dailyQuests", userId == null ? List.of() : ql("""
                SELECT q.code, q.title, q.icon, q.target_value, q.xp_reward, udq.current_value, udq.is_completed
                FROM user_daily_quests udq
                JOIN quests q ON q.id = udq.quest_id
                WHERE udq.user_id = ? AND udq.quest_date = CURRENT_DATE
                ORDER BY q.title
                """, userId));
        out.put("skills", userId == null ? List.of() : ql("""
                SELECT language, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score
                FROM user_skills
                WHERE user_id = ? AND language = ?
                ORDER BY updated_at DESC
                LIMIT 1
                """, userId, language));
        return out;
    }

    @GetMapping("/sections")
    public List<Map<String, Object>> sections(@RequestParam(name = "language", defaultValue = "es") String language) {
        return ql("""
                SELECT id, title, language, level, display_order
                FROM sections
                WHERE language = ?
                ORDER BY display_order ASC, title ASC
                """, language);
    }

    @GetMapping("/sections/{sectionId}")
    public Map<String, Object> sectionDetail(@PathVariable("sectionId") UUID sectionId) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("section", qm("SELECT id, title, language, level, display_order FROM sections WHERE id = ?", sectionId));
        out.put("units", ql("""
                SELECT id, section_id, title, description, topic_code, display_order
                FROM units
                WHERE section_id = ?
                ORDER BY display_order ASC, title ASC
                """, sectionId));
        return out;
    }

    @GetMapping("/units/{unitId}")
    public Map<String, Object> unitDetail(@PathVariable("unitId") UUID unitId) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("unit", qm("""
                SELECT id, section_id, title, description, topic_code, display_order
                FROM units
                WHERE id = ?
                """, unitId));
        out.put("lessons", ql("""
                SELECT id, unit_id, title, lesson_number, total_lessons_in_unit, lesson_type, estimated_minutes, xp_reward,
                       display_order, grammar_rule_id, reading_passage_id, prerequisite_lesson_id, unlock_condition
                FROM lessons
                WHERE unit_id = ?
                ORDER BY display_order ASC, lesson_number ASC
                """, unitId));
        return out;
    }

    @GetMapping("/lessons/{lessonId}")
    public Map<String, Object> lessonDetail(@PathVariable("lessonId") UUID lessonId) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("lesson", qm("""
                SELECT id, unit_id, title, lesson_number, total_lessons_in_unit, lesson_type, estimated_minutes, xp_reward,
                       display_order, grammar_rule_id, reading_passage_id, prerequisite_lesson_id, unlock_condition
                FROM lessons
                WHERE id = ?
                """, lessonId));
        out.put("exercises", ql("""
                SELECT id, lesson_id, exercise_type, prompt, options, correct_answer, hint, difficulty, display_order
                FROM exercises
                WHERE lesson_id = ?
                ORDER BY display_order ASC
                """, lessonId));
        return out;
    }

    @GetMapping("/lessons/{lessonId}/exercises")
    public List<Map<String, Object>> lessonExercises(@PathVariable("lessonId") UUID lessonId) {
        return ql("""
                SELECT id, lesson_id, exercise_type, prompt, options, correct_answer, hint, difficulty, display_order
                FROM exercises
                WHERE lesson_id = ?
                ORDER BY display_order ASC
                """, lessonId);
    }

    @GetMapping("/topics")
    public List<Map<String, Object>> topics(@RequestParam(name = "language", defaultValue = "es") String language) {
        return ql("SELECT id, code, name, icon, description, display_order FROM topics WHERE language = ? ORDER BY display_order", language);
    }

    @GetMapping("/topics/me")
    public List<Map<String, Object>> userTopics(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT t.id, t.code, t.name, t.icon, t.description, t.language
                FROM user_topics ut
                JOIN topics t ON t.id = ut.topic_id
                WHERE ut.user_id = ?
                ORDER BY t.display_order
                """, userId);
    }

    @GetMapping("/topics/{topicId}/content")
    public Map<String, Object> topicContent(@PathVariable("topicId") UUID topicId) {
        Map<String, Object> topic = qm("SELECT id, code, name, icon, description, language FROM topics WHERE id = ?", topicId);
        String code = String.valueOf(topic.get("code"));
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("topic", topic);
        out.put("units", ql("SELECT id, title, description, topic_code, display_order FROM units WHERE topic_code = ? ORDER BY display_order", code));
        out.put("vocabulary", ql("SELECT id, word, translation, topic_tag FROM vocabulary WHERE topic_tag = ? ORDER BY frequency_rank NULLS LAST, word LIMIT 100", code));
        out.put("phrases", ql("SELECT id, phrase, translation, topic_tag FROM phrases WHERE topic_tag = ? ORDER BY phrase LIMIT 100", code));
        return out;
    }

    @GetMapping("/vocabulary")
    public List<Map<String, Object>> vocabulary(@RequestParam(name = "language", defaultValue = "es") String language,
                                                @RequestParam(name = "userId", required = false) UUID userId,
                                                @RequestParam(name = "applyTopicFilter", defaultValue = "true") boolean applyTopicFilter) {
        UserContentProfile profile = userContentProfile(userId);
        String resolvedLanguage = profile != null && !profile.language().isBlank() ? profile.language() : language;
        String level = profile == null ? "" : profile.level();
        String goals = profile == null ? "" : profile.goalsCsv();
        return ql("""
                SELECT id, word, translation, example_sentence, phonetic_guide, audio_text, tags, topic_tag, level, frequency_rank
                FROM vocabulary
                WHERE language = ?
                  AND (? = '' OR level = ?)
                  AND (? = false OR ? = '' OR topic_tag = ANY (string_to_array(?, ',')))
                ORDER BY frequency_rank NULLS LAST, word ASC
                LIMIT 500
                """, resolvedLanguage, level, level, applyTopicFilter, goals, goals);
    }

    @GetMapping("/vocabulary/review")
    public List<Map<String, Object>> vocabularyReview(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT uwm.id, uwm.vocabulary_id, uwm.memory_strength, uwm.next_review_at, v.word, v.translation, v.example_sentence
                FROM user_word_memory uwm
                JOIN vocabulary v ON v.id = uwm.vocabulary_id
                WHERE uwm.user_id = ?
                ORDER BY uwm.next_review_at NULLS FIRST
                LIMIT 200
                """, userId);
    }

    @GetMapping("/vocabulary/memory")
    public List<Map<String, Object>> vocabularyMemory(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, vocabulary_id, times_seen, times_correct, times_incorrect, memory_strength, next_review_at, ease_factor
                FROM user_word_memory
                WHERE user_id = ?
                ORDER BY updated_at DESC
                LIMIT 300
                """, userId);
    }

    @GetMapping("/vocabulary/exercises")
    public List<Map<String, Object>> vocabularyExercises(@RequestParam(name = "language", defaultValue = "es") String language) {
        return ql("""
                SELECT e.id, e.lesson_id, e.exercise_type, e.prompt, e.options, e.correct_answer, e.hint, e.display_order
                FROM exercises e
                JOIN lessons l ON l.id = e.lesson_id
                JOIN units u ON u.id = l.unit_id
                JOIN sections s ON s.id = u.section_id
                WHERE s.language = ?
                  AND e.exercise_type IN ('IMAGE_PICK', 'FILL_BLANK', 'WORD_BANK')
                ORDER BY e.display_order ASC
                LIMIT 300
                """, language);
    }

    @GetMapping("/review")
    public Map<String, Object> review(@RequestParam("userId") UUID userId,
                                      @RequestParam(name = "language", defaultValue = "es") String language) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("sessions", ql("""
                SELECT id, status, total_items, items_reviewed, items_correct, xp_awarded, created_at, completed_at
                FROM review_sessions
                WHERE user_id = ? AND language = ?
                ORDER BY created_at DESC
                LIMIT 50
                """, userId, language));
        out.put("dueWords", ql("""
                SELECT id, vocabulary_id, memory_strength, next_review_at
                FROM user_word_memory
                WHERE user_id = ? AND (next_review_at IS NULL OR next_review_at <= now())
                ORDER BY next_review_at NULLS FIRST
                LIMIT 100
                """, userId));
        out.put("mistakes", ql("""
                SELECT id, mistake_type, reference_id, mistake_count, last_made_at, example_wrong, example_correct
                FROM common_mistakes
                WHERE user_id = ?
                ORDER BY mistake_count DESC, last_made_at DESC
                LIMIT 100
                """, userId));
        return out;
    }

    @GetMapping("/review/due")
    public List<Map<String, Object>> reviewDue(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, vocabulary_id, memory_strength, next_review_at
                FROM user_word_memory
                WHERE user_id = ? AND (next_review_at IS NULL OR next_review_at <= now())
                ORDER BY next_review_at NULLS FIRST
                LIMIT 100
                """, userId);
    }

    @GetMapping("/review/sessions")
    public List<Map<String, Object>> reviewSessions(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, language, session_type, status, total_items, items_reviewed, items_correct, xp_awarded, created_at, completed_at
                FROM review_sessions
                WHERE user_id = ?
                ORDER BY created_at DESC
                LIMIT 100
                """, userId);
    }

    @GetMapping("/my-mistakes")
    public List<Map<String, Object>> myMistakes(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, mistake_type, reference_id, mistake_count, last_made_at, example_wrong, example_correct
                FROM common_mistakes
                WHERE user_id = ?
                ORDER BY mistake_count DESC, last_made_at DESC
                """, userId);
    }

    @GetMapping("/lesson-queue")
    public List<Map<String, Object>> lessonQueue(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT lesson_id, reason, priority, is_completed, completed_at
                FROM personalized_lesson_queue
                WHERE user_id = ?
                ORDER BY priority DESC, lesson_id
                LIMIT 20
                """, userId);
    }

    @GetMapping("/grammar")
    public List<Map<String, Object>> grammar(@RequestParam(name = "language", defaultValue = "es") String language,
                                             @RequestParam(name = "userId", required = false) UUID userId) {
        UserContentProfile profile = userContentProfile(userId);
        String resolvedLanguage = profile != null && !profile.language().isBlank() ? profile.language() : language;
        String level = profile == null ? "" : profile.level();
        return ql("""
                SELECT id, code, title, explanation, examples, level, category, display_order
                FROM grammar_rules
                WHERE language = ?
                  AND (? = '' OR level = ?)
                ORDER BY display_order ASC, title ASC
                """, resolvedLanguage, level, level);
    }

    @GetMapping("/grammar/rules")
    public List<Map<String, Object>> grammarRules(@RequestParam(name = "language", defaultValue = "es") String language,
                                                  @RequestParam(name = "userId", required = false) UUID userId) {
        return grammar(language, userId);
    }

    @GetMapping("/grammar/rules/{id}")
    public Map<String, Object> grammarRuleDetail(@PathVariable("id") UUID id) {
        return qm("""
                SELECT id, code, language, title, explanation, examples, common_mistakes, related_rule_codes, level, category, display_order
                FROM grammar_rules
                WHERE id = ?
                """, id);
    }

    @GetMapping("/conjugations/verbs")
    public List<Map<String, Object>> conjugations(@RequestParam(name = "language", defaultValue = "es") String language) {
        return ql("""
                SELECT c.id, c.vocabulary_id, c.language, c.tense, c.mood, c.person, c.conjugated_form,
                       c.is_irregular, v.word AS vocabulary_word, v.translation AS vocabulary_translation
                FROM conjugations c
                JOIN vocabulary v ON v.id = c.vocabulary_id
                WHERE c.language = ?
                ORDER BY v.word, c.tense, c.person
                LIMIT 400
                """, language);
    }

    @GetMapping("/reading")
    public List<Map<String, Object>> reading(@RequestParam(name = "language", defaultValue = "es") String language,
                                             @RequestParam(name = "userId", required = false) UUID userId) {
        UserContentProfile profile = userContentProfile(userId);
        String resolvedLanguage = profile != null && !profile.language().isBlank() ? profile.language() : language;
        String level = profile == null ? "" : profile.level();
        String goals = profile == null ? "" : profile.goalsCsv();
        return ql("""
                SELECT id, title, body, translation, level, topic_tag, created_at
                FROM reading_passages
                WHERE language = ?
                  AND (? = '' OR level = ?)
                  AND (? = '' OR topic_tag = ANY (string_to_array(?, ',')))
                ORDER BY created_at DESC
                """, resolvedLanguage, level, level, goals, goals);
    }

    @GetMapping("/reading/passages")
    public List<Map<String, Object>> readingPassages(@RequestParam(name = "language", defaultValue = "es") String language,
                                                     @RequestParam(name = "userId", required = false) UUID userId) {
        return reading(language, userId);
    }

    @GetMapping("/reading/passages/{id}")
    public Map<String, Object> readingPassage(@PathVariable("id") UUID id) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("passage", qm("""
                SELECT id, language, title, body, translation, level, topic_tag, word_count, estimated_minutes
                FROM reading_passages
                WHERE id = ?
                """, id));
        out.put("questions", ql("""
                SELECT id, question_text, question_type, choices, correct_answer, explanation, display_order
                FROM reading_questions
                WHERE passage_id = ?
                ORDER BY display_order ASC
                """, id));
        return out;
    }

    @GetMapping("/phrases")
    public List<Map<String, Object>> phrases(@RequestParam(name = "language", defaultValue = "es") String language,
                                             @RequestParam(name = "userId", required = false) UUID userId) {
        UserContentProfile profile = userContentProfile(userId);
        String resolvedLanguage = profile != null && !profile.language().isBlank() ? profile.language() : language;
        String level = profile == null ? "" : profile.level();
        String goals = profile == null ? "" : profile.goalsCsv();
        return ql("""
                SELECT id, phrase, translation, phonetic_guide, topic_tag, context, level, audio_text, example_dialogue
                FROM phrases
                WHERE language = ?
                  AND (? = '' OR level = ?)
                  AND (? = '' OR topic_tag = ANY (string_to_array(?, ',')))
                ORDER BY phrase ASC
                """, resolvedLanguage, level, level, goals, goals);
    }

    @GetMapping("/cultural-notes")
    public List<Map<String, Object>> culturalNotes(@RequestParam(name = "language", defaultValue = "es") String language) {
        return ql("""
                SELECT id, language, title, body, topic_tag, level, display_order
                FROM cultural_notes
                WHERE language = ?
                ORDER BY title ASC
                """, language);
    }

    @GetMapping("/ai/templates")
    public List<Map<String, Object>> aiTemplates(@RequestParam(name = "language", defaultValue = "es") String language,
                                                 @RequestParam(name = "userId", required = false) UUID userId) {
        UserContentProfile profile = userContentProfile(userId);
        String resolvedLanguage = profile != null && !profile.language().isBlank() ? profile.language() : language;
        String level = profile == null ? "" : profile.level();
        String goals = profile == null ? "" : profile.goalsCsv();
        return ql("""
                SELECT id, language, title, scenario, topic_tag, level, opening_prompt, min_exchanges
                FROM ai_conversation_templates
                WHERE language = ?
                  AND (? = '' OR level = ?)
                  AND (? = '' OR topic_tag = ANY (string_to_array(?, ',')))
                ORDER BY title ASC
                """, resolvedLanguage, level, level, goals, goals);
    }

    @GetMapping("/ai/templates/{id}")
    public Map<String, Object> aiTemplate(@PathVariable("id") UUID id) {
        return qm("""
                SELECT id, language, title, scenario, topic_tag, level, opening_prompt, target_vocabulary, target_grammar_rules, min_exchanges, evaluation_criteria
                FROM ai_conversation_templates
                WHERE id = ?
                """, id);
    }

    @GetMapping("/me/quests")
    public List<Map<String, Object>> myQuests(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT udq.id, udq.quest_date, udq.current_value, udq.is_completed, q.code, q.title, q.icon, q.target_value, q.xp_reward
                FROM user_daily_quests udq
                JOIN quests q ON q.id = udq.quest_id
                WHERE udq.user_id = ?
                ORDER BY udq.quest_date DESC, q.title
                """, userId);
    }

    @GetMapping("/me/xp-history")
    public List<Map<String, Object>> xpHistory(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, amount, source, earned_at
                FROM xp_history
                WHERE user_id = ?
                ORDER BY earned_at DESC
                LIMIT 300
                """, userId);
    }

    @GetMapping("/me/level-history")
    public List<Map<String, Object>> levelHistory(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, change_type, previous_level, new_level, reason, changed_at
                FROM level_change_history
                WHERE user_id = ?
                ORDER BY changed_at DESC
                LIMIT 100
                """, userId);
    }

    @GetMapping("/me/activity")
    public List<Map<String, Object>> myActivity(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, lesson_id, exercise_id, action, from_exercise_order, to_exercise_order, timestamp AS nav_timestamp
                FROM lesson_navigation_log
                WHERE user_id = ?
                ORDER BY timestamp DESC
                LIMIT 200
                """, userId);
    }

    @GetMapping("/me/speaking-attempts")
    public List<Map<String, Object>> speakingAttempts(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, exercise_id, target_phrase, transcribed_text, similarity_score, passed, attempted_at
                FROM speaking_attempts
                WHERE user_id = ?
                ORDER BY attempted_at DESC
                LIMIT 200
                """, userId);
    }

    @GetMapping("/skills/me")
    public List<Map<String, Object>> mySkills(@RequestParam("userId") UUID userId,
                                              @RequestParam(name = "language", required = false) String language) {
        if (language == null || language.isBlank()) {
            return ql("""
                    SELECT id, language, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score, updated_at
                    FROM user_skills
                    WHERE user_id = ?
                    ORDER BY updated_at DESC
                    """, userId);
        }
        return ql("""
                SELECT id, language, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score, updated_at
                FROM user_skills
                WHERE user_id = ? AND language = ?
                ORDER BY updated_at DESC
                """, userId, language);
    }

    @GetMapping("/skills/breakdown-reports")
    public List<Map<String, Object>> skillBreakdownReports(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, language, report_date, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score,
                       weak_areas, strong_areas, recommended_focus, lessons_this_period, xp_this_period, generated_at
                FROM skill_breakdown_reports
                WHERE user_id = ?
                ORDER BY report_date DESC
                LIMIT 100
                """, userId);
    }

    @GetMapping("/skills/breakdown-live")
    public Map<String, Object> skillBreakdownLive(@RequestParam("userId") UUID userId,
                                                  @RequestParam(name = "language", defaultValue = "es") String language) {
        Map<String, Object> out = new LinkedHashMap<>();
        Map<String, Object> skill = latestSkillRow(userId, language);
        out.put("skills", skill);
        out.put("lessonMix", recommendedLessonMix(skill));
        out.put("milestone", milestoneStatus(userId, language, skill));
        return out;
    }

    @GetMapping("/skills/lesson-plan")
    public Map<String, Object> lessonPlan(@RequestParam("userId") UUID userId,
                                          @RequestParam(name = "language", defaultValue = "es") String language) {
        Map<String, Object> skill = latestSkillRow(userId, language);
        Map<String, Integer> mix = recommendedLessonMix(skill);
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("language", language);
        out.put("mix", mix);
        out.put("reason", "Weak skills are weighted more heavily (e.g., 40% if below threshold).");
        out.put("recommendedQueue", ql("""
                SELECT lesson_id, reason, priority, is_completed
                FROM personalized_lesson_queue
                WHERE user_id = ?
                ORDER BY priority DESC, lesson_id
                LIMIT 12
                """, userId));
        return out;
    }

    @PostMapping("/practice/attempt")
    public Map<String, Object> recordPracticeAttempt(@RequestBody PracticeAttemptRequest body) {
        if (body == null || body.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is required.");
        }
        String language = normalizeString(body.language()).isEmpty() ? "es" : normalizeString(body.language());
        String section = normalizeString(body.section()).toLowerCase();
        if (!List.of("vocabulary", "grammar", "listening", "writing", "speaking", "conversation").contains(section)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "section must be vocabulary, grammar, listening, writing, speaking, or conversation.");
        }
        boolean correct = Boolean.TRUE.equals(body.correct());
        int delta = correct ? 3 : -2;
        String scoreCol = switch (section) {
            case "vocabulary" -> "vocabulary_score";
            case "grammar" -> "grammar_score";
            case "listening" -> "listening_score";
            case "writing" -> "writing_score";
            case "speaking", "conversation" -> "speaking_score";
            default -> "overall_score";
        };

        Map<String, Object> row = latestSkillRow(body.userId(), language);
        int vocab = asInt(row.get("vocabulary_score"), 50);
        int grammar = asInt(row.get("grammar_score"), 50);
        int listening = asInt(row.get("listening_score"), 50);
        int writing = asInt(row.get("writing_score"), 50);
        int speaking = asInt(row.get("speaking_score"), 50);

        switch (scoreCol) {
            case "vocabulary_score" -> vocab = clampScore(vocab + delta);
            case "grammar_score" -> grammar = clampScore(grammar + delta);
            case "listening_score" -> listening = clampScore(listening + delta);
            case "writing_score" -> writing = clampScore(writing + delta);
            case "speaking_score" -> speaking = clampScore(speaking + delta);
            default -> {
            }
        }
        int overall = Math.round((vocab + grammar + listening + writing + speaking) / 5.0f);
        Instant now = Instant.now();

        Integer existing = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM user_skills
                WHERE user_id = ? AND language = ?
                """, Integer.class, body.userId(), language);

        if (existing != null && existing > 0) {
            jdbcTemplate.update("""
                    UPDATE user_skills
                    SET vocabulary_score = ?, grammar_score = ?, listening_score = ?, writing_score = ?, speaking_score = ?, overall_score = ?, updated_at = ?
                    WHERE user_id = ? AND language = ?
                    """, vocab, grammar, listening, writing, speaking, overall, now, body.userId(), language);
        } else {
            jdbcTemplate.update("""
                    INSERT INTO user_skills (id, user_id, language, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """, UUID.randomUUID(), body.userId(), language, vocab, grammar, listening, writing, speaking, overall, now);
        }

        jdbcTemplate.update("""
                INSERT INTO xp_history (id, user_id, amount, source, earned_at)
                VALUES (?, ?, ?, ?, ?)
                """, UUID.randomUUID(), body.userId(), correct ? 10 : 2, "practice:" + section, now);

        jdbcTemplate.update("""
                UPDATE users
                SET xp = COALESCE(xp, 0) + ?, streak_count = CASE WHEN last_active_date = ? THEN COALESCE(streak_count, 0) ELSE COALESCE(streak_count, 0) + 1 END,
                    last_active_date = ?, updated_at = ?
                WHERE id = ?
                """, correct ? 10 : 2, LocalDate.now(), LocalDate.now(), now, body.userId());

        Map<String, Object> updated = latestSkillRow(body.userId(), language);
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("ok", true);
        out.put("correct", correct);
        out.put("section", section);
        out.put("skills", updated);
        out.put("lessonMix", recommendedLessonMix(updated));
        out.put("milestone", milestoneStatus(body.userId(), language, updated));
        syncUserTroubleFromAttempt(body, language, section, correct);
        return out;
    }

    private void syncUserTroubleFromAttempt(PracticeAttemptRequest body, String language, String section, boolean correct) {
        try {
            String kind = normalizeString(body.contentKind()).toUpperCase(Locale.ROOT);
            UUID cid = body.contentId();
            String tag = normalizeString(body.topicTag());
            String label = normalizeString(body.labelSnapshot());

            if (cid == null && kind.isEmpty()) {
                if (!tag.isEmpty()) {
                    kind = "TOPIC";
                } else {
                    return;
                }
            }
            if ("TOPIC".equals(kind) && tag.isEmpty()) {
                return;
            }
            if (cid != null && kind.isEmpty()) {
                kind = switch (section) {
                    case "vocabulary" -> "VOCABULARY";
                    case "grammar" -> "GRAMMAR";
                    case "listening" -> "PHRASE";
                    case "conversation" -> "TEMPLATE";
                    case "writing" -> "READING";
                    default -> "";
                };
            }
            if (kind.isEmpty()) {
                return;
            }

            String dedupeKey = cid != null ? kind + ":" + cid : "TOPIC:" + tag.toUpperCase(Locale.ROOT);

            if (correct) {
                jdbcTemplate.update("""
                        DELETE FROM user_trouble_items
                        WHERE user_id = ? AND language = ? AND dedupe_key = ?
                        """, body.userId(), language, dedupeKey);
                return;
            }

            String topicForRow = tag.isEmpty() ? null : tag;
            String labelRow = label.isEmpty() ? null : label;
            jdbcTemplate.update("""
                    INSERT INTO user_trouble_items (id, user_id, language, section, reference_type, reference_id, topic_tag, label_snapshot, dedupe_key, wrong_count, last_wrong_at)
                    VALUES (gen_random_uuid(), ?, ?, ?, ?, ?, ?, ?, ?, 1, now())
                    ON CONFLICT (user_id, language, dedupe_key) DO UPDATE SET
                        wrong_count = user_trouble_items.wrong_count + 1,
                        last_wrong_at = now(),
                        label_snapshot = COALESCE(EXCLUDED.label_snapshot, user_trouble_items.label_snapshot),
                        section = EXCLUDED.section
                    """, body.userId(), language, section, kind, cid, topicForRow, labelRow, dedupeKey);
        } catch (Exception ignored) {
            // Table may be missing until database/user_trouble_items.sql is applied.
        }
    }

    @GetMapping("/practice/troubles")
    public List<Map<String, Object>> practiceTroubles(@RequestParam("userId") UUID userId,
                                                      @RequestParam(name = "language", defaultValue = "es") String language) {
        try {
            return ql("""
                    SELECT t.id, t.section, t.reference_type, t.reference_id, t.topic_tag, t.label_snapshot, t.wrong_count, t.last_wrong_at,
                           v.word AS detail_word, v.translation AS detail_translation,
                           g.title AS detail_grammar_title,
                           p.phrase AS detail_phrase, p.translation AS detail_phrase_translation,
                           tpl.title AS detail_template_title,
                           r.title AS detail_reading_title,
                           COALESCE(v.lesson_number, p.lesson_number) AS source_lesson_number
                    FROM user_trouble_items t
                    LEFT JOIN vocabulary v ON t.reference_type = 'VOCABULARY' AND t.reference_id = v.id
                    LEFT JOIN grammar_rules g ON t.reference_type = 'GRAMMAR' AND t.reference_id = g.id
                    LEFT JOIN phrases p ON t.reference_type = 'PHRASE' AND t.reference_id = p.id
                    LEFT JOIN ai_conversation_templates tpl ON t.reference_type = 'TEMPLATE' AND t.reference_id = tpl.id
                    LEFT JOIN reading_passages r ON t.reference_type = 'READING' AND t.reference_id = r.id
                    WHERE t.user_id = ?
                    ORDER BY t.last_wrong_at DESC, t.wrong_count DESC
                    LIMIT 200
                    """, userId);
        } catch (Exception ex) {
            return List.of();
        }
    }

    @GetMapping("/achievements/me")
    public List<Map<String, Object>> myAchievements(@RequestParam("userId") UUID userId) {
        List<Map<String, Object>> rows = ql("""
                SELECT
                    a.id AS achievement_id,
                    a.code,
                    a.name,
                    a.description,
                    a.icon,
                    a.max_level,
                    a.xp_reward,
                    a.thresholds,
                    ua.id AS user_achievement_id,
                    COALESCE(ua.current_level, 0) AS current_level,
                    COALESCE(ua.progress, 0) AS progress,
                    ua.unlocked_at
                FROM achievements a
                LEFT JOIN user_achievements ua
                    ON ua.achievement_id = a.id
                    AND ua.user_id = ?
                ORDER BY
                    CASE WHEN ua.unlocked_at IS NULL THEN 1 ELSE 0 END,
                    ua.unlocked_at DESC,
                    a.name
                """, userId);

        int userXp = scalarInt("SELECT COALESCE(xp, 0) FROM users WHERE id = ?", userId);
        int userStreak = scalarInt("SELECT COALESCE(streak_count, 0) FROM users WHERE id = ?", userId);
        int coreCompleted = scalarInt("""
                SELECT COUNT(*)
                FROM user_lesson_catalog_progress
                WHERE user_id = ? AND passed = true
                """, userId);
        int topicCompleted = scalarInt("""
                SELECT COUNT(*)
                FROM user_lesson_progress
                WHERE user_id = ? AND status = 'COMPLETED'
                """, userId);
        int aiSessions = scalarInt("SELECT COUNT(*) FROM ai_sessions WHERE user_id = ?", userId);
        int premiumActive = scalarInt("""
                SELECT COUNT(*)
                FROM subscriptions
                WHERE user_id = ?
                  AND status = 'ACTIVE'
                  AND (expires_at IS NULL OR expires_at >= now())
                """, userId) > 0 ? 1 : 0;
        int perfectLessonCount = scalarInt("""
                SELECT COUNT(*)
                FROM user_lesson_catalog_progress
                WHERE user_id = ? AND passed = true AND COALESCE(score_percentage, 0) >= 100
                """, userId);

        Instant now = Instant.now();
        for (Map<String, Object> row : rows) {
            String code = normalizeString(row.get("code")).toUpperCase(Locale.ROOT);
            int existingProgress = asInt(row.get("progress"));
            int computedProgress = switch (code) {
                case "BOOKWORM" -> coreCompleted + topicCompleted;
                case "XP_COLLECTOR" -> userXp;
                case "WILDFIRE" -> userStreak;
                case "CONVERSATIONALIST" -> aiSessions;
                case "PREMIUM_LEARNER" -> premiumActive;
                case "PERFECTIONIST" -> perfectLessonCount;
                case "UNIT_COMPLETE" -> topicCompleted;
                default -> existingProgress;
            };
            int progress = Math.max(existingProgress, computedProgress);
            List<Integer> thresholds = achievementThresholds(row.get("thresholds"));
            int maxLevel = Math.max(1, asInt(row.get("max_level")));
            int computedLevel = 0;
            for (int i = 0; i < thresholds.size() && i < maxLevel; i++) {
                if (progress >= thresholds.get(i)) {
                    computedLevel = i + 1;
                }
            }
            int level = Math.max(asInt(row.get("current_level")), computedLevel);
            row.put("progress", progress);
            row.put("current_level", level);
            if (level > 0 && row.get("unlocked_at") == null) {
                row.put("unlocked_at", now.toString());
            }

            try {
                Timestamp unlockedAt = level > 0 ? Timestamp.from(now) : null;
                jdbcTemplate.update("""
                        INSERT INTO user_achievements (id, user_id, achievement_id, current_level, progress, unlocked_at)
                        VALUES (?::uuid, ?::uuid, ?::uuid, ?, ?, ?)
                        ON CONFLICT (user_id, achievement_id) DO UPDATE SET
                            current_level = GREATEST(user_achievements.current_level, EXCLUDED.current_level),
                            progress = GREATEST(user_achievements.progress, EXCLUDED.progress),
                            unlocked_at = COALESCE(user_achievements.unlocked_at, EXCLUDED.unlocked_at)
                        """,
                        UUID.randomUUID().toString(),
                        userId.toString(),
                        String.valueOf(row.get("achievement_id")),
                        level,
                        progress,
                        unlockedAt);
            } catch (Exception ignored) {
                // Never fail achievements endpoint because one upsert row failed.
            }
        }
        return rows;
    }

    private int scalarInt(String sql, Object... args) {
        try {
            Number n = jdbcTemplate.queryForObject(sql, Number.class, args);
            return n == null ? 0 : n.intValue();
        } catch (Exception ignored) {
            return 0;
        }
    }

    private int asInt(Object value) {
        if (value == null) return 0;
        if (value instanceof Number n) return n.intValue();
        try {
            return Integer.parseInt(String.valueOf(value).trim());
        } catch (Exception ignored) {
            return 0;
        }
    }

    private List<Integer> achievementThresholds(Object raw) {
        try {
            JsonNode node;
            if (raw instanceof Map<?, ?> map) {
                node = JSON.valueToTree(map);
            } else {
                node = JSON.readTree(String.valueOf(raw));
            }
            JsonNode levelsNode = node.path("levels");
            if (!levelsNode.isArray()) return List.of();
            List<Integer> out = new java.util.ArrayList<>();
            for (JsonNode level : levelsNode) {
                if (level.canConvertToInt()) out.add(level.asInt());
            }
            return out;
        } catch (Exception ignored) {
            return List.of();
        }
    }

    @GetMapping("/notifications")
    public List<Map<String, Object>> notifications(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, type, title, body, is_read, sent_at, scheduled_at, delivery_status, channel
                FROM notifications
                WHERE user_id = ?
                ORDER BY sent_at DESC
                LIMIT 200
                """, userId);
    }

    @GetMapping("/leaderboard")
    public List<Map<String, Object>> leaderboard() {
        return ql("""
                SELECT id, user_id, week_start, xp_earned, league, rank
                FROM leaderboard_entries
                ORDER BY week_start DESC, xp_earned DESC NULLS LAST, rank ASC NULLS LAST
                LIMIT 100
                """);
    }

    @GetMapping("/preferences")
    public List<Map<String, Object>> preferences(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT user_id, daily_goal_xp, session_length_minutes, preferred_exercise_types, weak_skills_focus, spaced_repetition_on
                FROM user_learning_preferences
                WHERE user_id = ?
                """, userId);
    }

    @GetMapping("/accessibility")
    public List<Map<String, Object>> accessibility(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT user_id, high_contrast_mode, font_size, reduced_motion, screen_reader_mode, color_blind_mode, updated_at
                FROM accessibility_preferences
                WHERE user_id = ?
                """, userId);
    }

    @GetMapping("/subscriptions/me")
    public List<Map<String, Object>> mySubscription(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, plan, status, started_at, expires_at, auto_renew, amount_paid, currency
                FROM subscriptions
                WHERE user_id = ?
                ORDER BY started_at DESC
                LIMIT 1
                """, userId);
    }

    @GetMapping("/subscriptions/history")
    public List<Map<String, Object>> subscriptionHistory(@RequestParam("userId") UUID userId) {
        return ql("""
                SELECT id, plan, status, started_at, expires_at, auto_renew, amount_paid, currency, cancelled_at
                FROM subscriptions
                WHERE user_id = ?
                ORDER BY started_at DESC
                """, userId);
    }

    @PostMapping("/subscriptions/subscribe")
    public Map<String, Object> subscribe(@RequestBody SubscriptionActionRequest body) {
        if (body == null || body.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is required.");
        }
        String plan = normalizeString(body.plan());
        if (plan.isEmpty()) plan = "PREMIUM_MONTHLY";
        Instant now = Instant.now();
        Instant exp = now.plusSeconds(30L * 24L * 60L * 60L);
        jdbcTemplate.update("""
                INSERT INTO subscriptions (id, user_id, plan, status, started_at, expires_at, auto_renew, amount_paid, currency)
                VALUES (?, ?, ?, 'ACTIVE', ?, ?, ?, ?, ?)
                """, UUID.randomUUID(), body.userId(), plan, now, exp, body.autoRenew() == null || body.autoRenew(), 19.99, "USD");
        return Map.of("ok", true, "plan", plan, "status", "ACTIVE", "expiresAt", exp.toString());
    }

    @PatchMapping("/subscriptions/manage")
    public Map<String, Object> manageSubscription(@RequestBody SubscriptionActionRequest body) {
        if (body == null || body.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is required.");
        }
        jdbcTemplate.update("""
                UPDATE subscriptions
                SET auto_renew = ?, status = CASE WHEN status = 'CANCELLED' THEN 'CANCELLED' ELSE 'ACTIVE' END
                WHERE user_id = ? AND id IN (
                    SELECT id FROM subscriptions WHERE user_id = ? ORDER BY started_at DESC LIMIT 1
                )
                """, body.autoRenew() != null && body.autoRenew(), body.userId(), body.userId());
        return Map.of("ok", true, "autoRenew", body.autoRenew() != null && body.autoRenew());
    }

    @PatchMapping("/subscriptions/cancel")
    public Map<String, Object> cancelSubscription(@RequestBody SubscriptionActionRequest body) {
        if (body == null || body.userId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId is required.");
        }
        String reason = normalizeString(body.cancelReason());
        jdbcTemplate.update("""
                UPDATE subscriptions
                SET status = 'CANCELLED', cancelled_at = ?, cancellation_reason = ?, auto_renew = false
                WHERE user_id = ? AND id IN (
                    SELECT id FROM subscriptions WHERE user_id = ? ORDER BY started_at DESC LIMIT 1
                )
                """, Instant.now(), reason.isEmpty() ? "User cancelled from dashboard" : reason, body.userId(), body.userId());
        return Map.of("ok", true, "status", "CANCELLED");
    }

    @PostMapping("/ai/conversation/feedback")
    public Map<String, Object> aiConversationFeedback(@RequestBody AiConversationRequest body) {
        if (body == null || normalizeString(body.userMessage()).isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userMessage is required.");
        }
        String msg = normalizeString(body.userMessage());
        if (containsInappropriateContent(msg)) {
            return Map.of(
                    "ok", true,
                    "assistantReply", "I can not help with that. I can help with respectful language-learning questions instead.",
                    "grammarScore", 0,
                    "pronunciationScore", 0,
                    "grammarFeedback", "Message blocked by safety policy.",
                    "pronunciationFeedback", "Please ask a safe language-learning question."
            );
        }
        String language = normalizeString(body.language()).toLowerCase();
        if (language.isEmpty()) language = "es";
        String mode = normalizeString(body.mode()).toLowerCase();
        if (mode.isEmpty()) mode = "tutor";
        boolean spanishOnlyMode = mode.equals("spanish_only");

        String learningLabel = language.startsWith("es") ? "Spanish" : language.startsWith("en") ? "English" : "the target language";
        String nativeLabel = language.startsWith("es") ? "English" : language.startsWith("en") ? "Spanish" : "English";
        String nativeCode = language.startsWith("es") ? "en" : language.startsWith("en") ? "es" : "en";
        String targetCode = language.startsWith("es") ? "es" : language.startsWith("en") ? "en" : language;
        String modeInstruction = spanishOnlyMode
                ? """
                Conversation mode:
                - Speak ONLY in the learner target language.
                - Be natural and fluent like a native speaker.
                - Do not switch to the learner native language unless the user explicitly asks.
                - Avoid explicit corrections unless the learner requests correction.
                """
                : """
                Tutor mode:
                - Be a warm language tutor.
                - Explain in the learner native language by default.
                - Always include the key target-language phrase(s) clearly in straight double quotes.
                - Inside quotes, write the real target-language spelling only (with proper accents/punctuation).
                - Never put phonetic respellings inside quotes (avoid forms like "dohn-de", "komo", etc.).
                - If the user asks how to say something, give: (1) natural translation, (2) short pronunciation help, (3) one alternate phrasing when useful.
                - Put pronunciation help outside the quoted target-language phrase.
                - If the user makes mistakes, give gentle corrections and a better phrasing.
                - Keep corrections concise, practical, and encouraging.
                """;

        String systemPrompt = """
                You are Fluentia Tutor, a friendly human-like language coach.
                Context:
                - Learner native language: %s (%s)
                - Learner target language: %s (%s)
                - Active mode: %s

                Style requirements:
                - Sound natural, warm, and conversational, like a real tutor in chat.
                - Avoid rigid templates, headings, and bullet lists unless the user asks for them.
                - Do not use markdown bold for simple answers.
                - Keep it concise (usually 2-5 sentences), clear, and practical.
                - Explain in the learner's native language, but include target-language examples naturally in-line.
                - Offer one gentle follow-up question sometimes, not every single message.

                Teaching behavior:
                - If user asks "how do I say X", give the most natural phrase first, then optionally one alternative.
                - Add a short pronunciation tip only when useful.
                - Prefer everyday phrasing over textbook phrasing.

                Safety:
                - Refuse inappropriate, sexual, hateful, violent, illegal, or self-harm requests.
                - Briefly redirect back to safe language-learning help.
                
                %s
                """.formatted(nativeLabel, nativeCode, learningLabel, targetCode, mode, modeInstruction);

        Map<String, Object> aiResult = callOpenAiTutor(systemPrompt, msg);
        if (aiResult != null) {
            Map<String, Object> out = new LinkedHashMap<>(aiResult);
            out.put("language", language);
            out.put("mode", mode);
            return out;
        }

        int grammarScore = 84;
        int pronunciationScore = 82;
        String grammarFeedback = "Live AI is unavailable right now. Check your OpenAI key/config and retry.";
        String pronunciationFeedback = "Fallback mode active. Once OpenAI connects, you will get personalized pronunciation coaching.";
        String assistantReply = language.startsWith("es")
                ? "Could not reach AI tutor. En inglés nativo: tell me what you want to say, and I will translate it to Spanish with alternatives."
                : "No se pudo conectar al tutor IA. En tu idioma nativo: dime lo que quieres decir y lo traduzco al ingles con alternativas.";
        return Map.of(
                "ok", true,
                "language", language,
                "mode", mode,
                "assistantReply", assistantReply,
                "grammarScore", grammarScore,
                "pronunciationScore", pronunciationScore,
                "grammarFeedback", grammarFeedback,
                "pronunciationFeedback", pronunciationFeedback
        );
    }

    private Map<String, Object> callOpenAiTutor(String systemPrompt, String userMessage) {
        String apiKey = resolveOpenAiKey();
        if (apiKey.isEmpty()) return null;
        try {
            HttpClient client = HttpClient.newHttpClient();
            JsonNode payload = JSON.createObjectNode()
                    .put("model", "gpt-4o-mini")
                    .put("temperature", 0.45)
                    .set("messages", JSON.createArrayNode()
                            .add(JSON.createObjectNode().put("role", "system").put("content", systemPrompt))
                            .add(JSON.createObjectNode().put("role", "user").put("content", userMessage)));

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://api.openai.com/v1/chat/completions"))
                    .header("Authorization", "Bearer " + apiKey)
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(JSON.writeValueAsString(payload)))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) return null;

            JsonNode root = JSON.readTree(response.body());
            String assistantReply = root.path("choices").path(0).path("message").path("content").asText("");
            if (assistantReply.isBlank()) return null;

            return Map.of(
                    "ok", true,
                    "assistantReply", assistantReply.trim(),
                    "grammarScore", 95,
                    "pronunciationScore", 92,
                    "grammarFeedback", "AI tutor response generated from your prompt.",
                    "pronunciationFeedback", "Use the pronunciation hints in the AI reply and repeat aloud."
            );
        } catch (Exception ex) {
            return null;
        }
    }

    private String resolveOpenAiKey() {
        String[] keys = new String[]{"OPENAI_API_KEY", "OPENAI_KEY"};
        for (String key : keys) {
            String fromProp = System.getProperty(key);
            if (fromProp != null && !fromProp.isBlank()) return fromProp.trim();
            String fromEnv = System.getenv(key);
            if (fromEnv != null && !fromEnv.isBlank()) return fromEnv.trim();
        }
        return "";
    }

    private boolean containsInappropriateContent(String text) {
        String norm = normalizeString(text).toLowerCase();
        if (norm.isEmpty()) return false;
        for (String token : INAPPROPRIATE_PATTERNS) {
            if (norm.contains(token)) return true;
        }
        return false;
    }

    private int count(String table, String col, String value) {
        Integer c = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM " + table + " WHERE " + col + " = ?", Integer.class, value);
        return c == null ? 0 : c;
    }

    private static int asInt(Object value, int fallback) {
        if (value == null) return fallback;
        if (value instanceof Number n) return n.intValue();
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception ex) {
            return fallback;
        }
    }

    private static int clampScore(int value) {
        return Math.max(0, Math.min(100, value));
    }

    private Map<String, Object> latestSkillRow(UUID userId, String language) {
        List<Map<String, Object>> rows = ql("""
                SELECT id, user_id, language, vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, overall_score, updated_at
                FROM user_skills
                WHERE user_id = ? AND language = ?
                ORDER BY updated_at DESC
                LIMIT 1
                """, userId, language);
        if (!rows.isEmpty()) {
            return rows.get(0);
        }
        Map<String, Object> seed = new LinkedHashMap<>();
        seed.put("user_id", userId);
        seed.put("language", language);
        seed.put("vocabulary_score", 50);
        seed.put("grammar_score", 50);
        seed.put("listening_score", 50);
        seed.put("writing_score", 50);
        seed.put("speaking_score", 50);
        seed.put("overall_score", 50);
        return seed;
    }

    private Map<String, Integer> recommendedLessonMix(Map<String, Object> skillRow) {
        int vocabulary = asInt(skillRow.get("vocabulary_score"), 50);
        int grammar = asInt(skillRow.get("grammar_score"), 50);
        int listening = asInt(skillRow.get("listening_score"), 50);
        int writing = asInt(skillRow.get("writing_score"), 50);
        int speaking = asInt(skillRow.get("speaking_score"), 50);

        Map<String, Integer> out = new LinkedHashMap<>();
        out.put("vocabulary", 15);
        out.put("grammar", 15);
        out.put("listening", 15);
        out.put("writing", 15);
        out.put("conversation", 15);
        out.put("review", 25);

        if (grammar < 60) out.put("grammar", 40);
        if (vocabulary < 60) out.put("vocabulary", 40);
        if (listening < 60) out.put("listening", 40);
        if (writing < 60) out.put("writing", 40);
        if (speaking < 60) out.put("conversation", 40);

        int sum = out.values().stream().mapToInt(Integer::intValue).sum();
        if (sum != 100) {
            // Normalize back to 100 while preserving relative weights.
            int running = 0;
            int i = 0;
            for (Map.Entry<String, Integer> e : out.entrySet()) {
                i++;
                int adjusted = i == out.size() ? (100 - running) : Math.round((e.getValue() * 100f) / sum);
                e.setValue(adjusted);
                running += adjusted;
            }
        }
        return out;
    }

    private Map<String, Object> milestoneStatus(UUID userId, String language, Map<String, Object> skillRow) {
        int overall = asInt(skillRow.get("overall_score"), 50);
        int attempts = asInt(jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM xp_history
                WHERE user_id = ? AND source LIKE 'practice:%'
                """, Integer.class, userId), 0);
        boolean reassessRecommended = attempts >= 40 && overall >= 70;
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("language", language);
        out.put("practiceAttempts", attempts);
        out.put("overallScore", overall);
        out.put("reassessRecommended", reassessRecommended);
        out.put("nextMilestoneAtAttempts", 40);
        return out;
    }

    private int countUnitsByLanguage(String language) {
        Integer c = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM units u
                JOIN sections s ON s.id = u.section_id
                WHERE s.language = ?
                """, Integer.class, language);
        return c == null ? 0 : c;
    }

    private int countLessonsByLanguage(String language) {
        Integer c = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM lessons l
                JOIN units u ON u.id = l.unit_id
                JOIN sections s ON s.id = u.section_id
                WHERE s.language = ?
                """, Integer.class, language);
        return c == null ? 0 : c;
    }

    private int countExercisesByLanguage(String language) {
        Integer c = jdbcTemplate.queryForObject("""
                SELECT COUNT(*)
                FROM exercises e
                JOIN lessons l ON l.id = e.lesson_id
                JOIN units u ON u.id = l.unit_id
                JOIN sections s ON s.id = u.section_id
                WHERE s.language = ?
                """, Integer.class, language);
        return c == null ? 0 : c;
    }
}
