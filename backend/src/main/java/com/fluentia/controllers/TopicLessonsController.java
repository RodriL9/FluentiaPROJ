package com.fluentia.controllers;

import com.fluentia.config.JdbcJsonNormalizer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

/**
 * TopicLessonsController
 *
 * Handles the personalized topic-based lessons from the big `lessons` table.
 * These are filtered by:
 *   - User's assigned level
 *   - User's chosen topics (from user_topics)
 *   - Language they are learning
 *
 * Endpoints:
 *  GET /api/topic-lessons?userId=...   → sections/units/lessons for user's level + topics
 *  GET /api/topic-lessons/{lessonId}   → single lesson detail with exercises
 *  POST /api/topic-lessons/{lessonId}/complete → mark complete + award XP
 */
@RestController
@RequestMapping("/topic-lessons")
public class TopicLessonsController {

    private final JdbcTemplate jdbc;
    private final JdbcJsonNormalizer normalizer;

    public TopicLessonsController(JdbcTemplate jdbc, JdbcJsonNormalizer normalizer) {
        this.jdbc = jdbc;
        this.normalizer = normalizer;
    }

    // ── GET /api/topic-lessons?userId=...
    // Returns units/lessons grouped by section, filtered by user's level + topics
    @GetMapping
    public Map<String, Object> getTopicLessons(@RequestParam String userId) {

        // Get user info
        List<Map<String, Object>> userRows = jdbc.queryForList("""
            SELECT assigned_level, learning_language
            FROM users WHERE id = ?::uuid
            """, userId);

        if (userRows.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }

        String level = (String) userRows.get(0).get("assigned_level");
        String language = (String) userRows.get(0).get("learning_language");
        if (level == null) level = "BEGINNER";

        // Get user's chosen topic codes
        List<String> userTopicCodes = jdbc.queryForList("""
            SELECT UPPER(t.code) as code
            FROM user_topics ut
            JOIN topics t ON ut.topic_id = t.id
            WHERE ut.user_id = ?::uuid
            """, String.class, userId);

        // Get sections for user's level and language
        List<Map<String, Object>> sections = jdbc.queryForList("""
            SELECT id, title, level, language, display_order
            FROM sections
            WHERE language = ? AND level = ?
            ORDER BY display_order ASC
            """, language, level);

        // For each section, get units filtered by user's topics
        List<Map<String, Object>> result = new ArrayList<>();

        for (Map<String, Object> section : sections) {
            UUID sectionId = (UUID) section.get("id");

            // Build topic filter query
            String topicFilter = userTopicCodes.isEmpty() ? "" :
                "AND UPPER(u.topic_code) = ANY(ARRAY[" +
                String.join(",", userTopicCodes.stream().map(c -> "'" + c + "'").toList()) +
                "]::text[])";

            List<Map<String, Object>> units = jdbc.queryForList("""
                SELECT u.id, u.title, u.description, u.topic_code, u.display_order
                FROM units u
                WHERE u.section_id = ?
                """ + topicFilter + """
                ORDER BY u.display_order ASC
                """, sectionId);

            // For each unit get lessons with user progress
            for (Map<String, Object> unit : units) {
                UUID unitId = (UUID) unit.get("id");

                List<Map<String, Object>> lessons = jdbc.queryForList("""
                    SELECT 
                        l.id,
                        l.title,
                        l.lesson_number,
                        l.lesson_type,
                        l.xp_reward,
                        l.estimated_minutes,
                        l.display_order,
                        COALESCE(ulp.status, 'AVAILABLE') as status,
                        COALESCE(ulp.score_percentage, 0) as score_percentage,
                        COALESCE(ulp.xp_earned, 0) as xp_earned,
                        COALESCE(ulp.attempts, 0) as attempts,
                        ulp.completed_at
                    FROM lessons l
                    LEFT JOIN user_lesson_progress ulp 
                        ON ulp.lesson_id = l.id AND ulp.user_id = ?::uuid
                    WHERE l.unit_id = ?
                    ORDER BY l.display_order ASC
                    """, userId, unitId);

                unit.put("lessons", lessons);
            }

            if (!units.isEmpty()) {
                Map<String, Object> sectionResult = new HashMap<>(section);
                sectionResult.put("units", units);
                result.add(sectionResult);
            }
        }

        return Map.of(
            "level", level,
            "language", language,
            "userTopics", userTopicCodes,
            "sections", result
        );
    }

    // ── GET /api/topic-lessons/{lessonId}?userId=...
    // Returns a single lesson's content and exercises
    @GetMapping("/{lessonId}")
    public Map<String, Object> getLessonDetail(
            @PathVariable UUID lessonId,
            @RequestParam String userId) {

        List<Map<String, Object>> lessonRows = jdbc.queryForList("""
            SELECT l.*, 
                   u.title as unit_title, u.topic_code,
                   s.title as section_title, s.level, s.language
            FROM lessons l
            JOIN units u ON l.unit_id = u.id
            JOIN sections s ON u.section_id = s.id
            WHERE l.id = ?
            """, lessonId);

        if (lessonRows.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        Map<String, Object> lesson = lessonRows.get(0);
        normalizer.normalizeRow(lesson);

        // Get exercises
        List<Map<String, Object>> exercises = jdbc.queryForList("""
            SELECT id, exercise_type, prompt, options, correct_answer,
                   audio_text, hint, display_order, skill_tested, difficulty,
                   accepted_answers, phonetic_guide
            FROM exercises
            WHERE lesson_id = ?
            ORDER BY display_order ASC
            """, lessonId);
        normalizer.normalizeRows(exercises);

        // Get user progress for this lesson
        List<Map<String, Object>> progressRows = jdbc.queryForList("""
            SELECT status, score_percentage, xp_earned, attempts, completed_at, started_at
            FROM user_lesson_progress
            WHERE user_id = ?::uuid AND lesson_id = ?
            """, userId, lessonId);

        lesson.put("exercises", exercises);
        lesson.put("exerciseCount", exercises.size());
        lesson.put("progress", progressRows.isEmpty() ? null : progressRows.get(0));

        return lesson;
    }

    // ── POST /api/topic-lessons/{lessonId}/complete
    // Marks a topic lesson as complete and awards XP
    @PostMapping("/{lessonId}/complete")
    public Map<String, Object> completeLesson(
            @PathVariable UUID lessonId,
            @RequestBody Map<String, Object> body) {

        String userId = (String) body.get("userId");
        int exercisesCorrect = toInt(body.get("exercisesCorrect"), 0);
        int exercisesTotal = toInt(body.get("exercisesTotal"), 0);
        int timeSpentSeconds = toInt(body.get("timeSpentSeconds"), 0);

        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId required");
        }

        // Get lesson XP reward
        List<Map<String, Object>> lessonRows = jdbc.queryForList(
            "SELECT xp_reward FROM lessons WHERE id = ?", lessonId);
        if (lessonRows.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }

        int xpReward = toInt(lessonRows.get(0).get("xp_reward"), 10);
        double scorePct = exercisesTotal > 0
            ? (exercisesCorrect * 100.0 / exercisesTotal) : 0;

        // Upsert user_lesson_progress
        jdbc.update("""
            INSERT INTO user_lesson_progress 
                (user_id, lesson_id, status, exercises_correct, exercises_total,
                 score_percentage, xp_earned, time_spent_seconds, attempts, completed_at, started_at)
            VALUES (?::uuid, ?, 'COMPLETED', ?, ?, ?, ?, ?, 1, now(), now())
            ON CONFLICT (user_id, lesson_id) DO UPDATE SET
                status = 'COMPLETED',
                exercises_correct = EXCLUDED.exercises_correct,
                exercises_total = EXCLUDED.exercises_total,
                score_percentage = EXCLUDED.score_percentage,
                xp_earned = EXCLUDED.xp_earned,
                time_spent_seconds = EXCLUDED.time_spent_seconds,
                attempts = user_lesson_progress.attempts + 1,
                completed_at = now()
            """,
            userId, lessonId,
            exercisesCorrect, exercisesTotal,
            scorePct, xpReward, timeSpentSeconds);

        // Add XP to user
        jdbc.update("""
            UPDATE users SET xp = COALESCE(xp, 0) + ?, updated_at = now()
            WHERE id = ?::uuid
            """, xpReward, userId);

        // Log XP history
        jdbc.update("""
            INSERT INTO xp_history (user_id, amount, source, earned_at)
            VALUES (?::uuid, ?, 'LESSON', now())
            """, userId, xpReward);

        // Log wrong answers as trouble items
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> wrongAnswers =
            (List<Map<String, Object>>) body.getOrDefault("wrongAnswers", List.of());
        for (Map<String, Object> wa : wrongAnswers) {
            try {
                String lang = (String) wa.getOrDefault("language", "es");
                String section = (String) wa.getOrDefault("section", "vocabulary");
                String label = (String) wa.getOrDefault("label", "");
                String dedupeKey = section + ":" + label;

                jdbc.update("""
                    INSERT INTO user_trouble_items 
                        (user_id, language, section, label_snapshot, dedupe_key, wrong_count, last_wrong_at)
                    VALUES (?::uuid, ?, ?, ?, ?, 1, now())
                    ON CONFLICT (user_id, language, dedupe_key) DO UPDATE SET
                        wrong_count = user_trouble_items.wrong_count + 1,
                        last_wrong_at = now(),
                        updated_at = now()
                    """, userId, lang, section, label, dedupeKey);
            } catch (Exception ignored) {}
        }

        return Map.of(
            "ok", true,
            "xpEarned", xpReward,
            "scorePct", scorePct,
            "exercisesCorrect", exercisesCorrect,
            "exercisesTotal", exercisesTotal
        );
    }

    private int toInt(Object val, int def) {
        if (val == null) return def;
        try { return ((Number) val).intValue(); } catch (Exception e) { return def; }
    }
}