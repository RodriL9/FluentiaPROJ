package com.fluentia.controllers;
 
import com.fluentia.config.JdbcJsonNormalizer;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;
 
import java.time.LocalDate;
import java.util.*;
 
@RestController
@RequestMapping("/lesson-catalog")
public class LessonCatalogController {
 
    private final JdbcTemplate jdbc;
    private final JdbcJsonNormalizer normalizer;
 
    public LessonCatalogController(JdbcTemplate jdbc, JdbcJsonNormalizer normalizer) {
        this.jdbc = jdbc;
        this.normalizer = normalizer;
    }
 
    @GetMapping
    public List<Map<String, Object>> getLessonCatalog(@RequestParam String userId) {
        List<Map<String, Object>> rows = jdbc.queryForList("""
                SELECT
                    lc.lesson_number,
                    lc.title,
                    lc.table_name,
                    lc.description,
                    COALESCE(ulcp.status, 'LOCKED') as status,
                    COALESCE(ulcp.score_percentage, 0) as score_percentage,
                    COALESCE(ulcp.xp_earned, 0) as xp_earned,
                    COALESCE(ulcp.attempts, 0) as attempts,
                    COALESCE(ulcp.passed, false) as passed,
                    ulcp.completed_at,
                    ulcp.started_at
                FROM lesson_catalog lc
                LEFT JOIN user_lesson_catalog_progress ulcp
                    ON ulcp.lesson_number = lc.lesson_number
                    AND ulcp.user_id = ?::uuid
                ORDER BY lc.lesson_number ASC
                """, userId);
        return rows;
    }
 
    @GetMapping("/{lessonNumber}/content")
    public Map<String, Object> getLessonContent(
            @PathVariable int lessonNumber,
            @RequestParam String userId) {
 
        List<Map<String, Object>> userRows = jdbc.queryForList("""
                SELECT assigned_level, learning_language, native_language
                FROM users WHERE id = ?::uuid
                """, userId);
 
        if (userRows.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found");
        }
 
        String level = (String) userRows.get(0).get("assigned_level");
        String language = (String) userRows.get(0).get("learning_language");
        if (level == null)
            level = "BEGINNER";
 
        List<Map<String, Object>> catalogRows = jdbc.queryForList(
                "SELECT * FROM lesson_catalog WHERE lesson_number = ?", lessonNumber);
        if (catalogRows.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Lesson not found");
        }
        Map<String, Object> lesson = catalogRows.get(0);
 
        List<Map<String, Object>> content = loadContentForLesson(lessonNumber, level, language);
 
        Map<String, Object> result = new HashMap<>();
        result.put("lessonNumber", lessonNumber);
        result.put("title", lesson.get("title"));
        result.put("description", lesson.get("description"));
        result.put("tableName", lesson.get("table_name"));
        result.put("level", level);
        result.put("language", language);
        result.put("content", content);
        result.put("totalItems", content.size());
        return result;
    }
 
    @PostMapping("/{lessonNumber}/start")
    public Map<String, Object> startLesson(
            @PathVariable int lessonNumber,
            @RequestBody Map<String, Object> body) {
 
        String userId = (String) body.get("userId");
        if (userId == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId required");
 
        jdbc.update("""
                INSERT INTO user_lesson_catalog_progress
                    (user_id, lesson_number, status, started_at)
                VALUES (?::uuid, ?, 'IN_PROGRESS', now())
                ON CONFLICT (user_id, lesson_number) DO UPDATE SET
                    status = CASE
                        WHEN user_lesson_catalog_progress.status = 'AVAILABLE' THEN 'IN_PROGRESS'
                        ELSE user_lesson_catalog_progress.status
                    END,
                    started_at = CASE
                        WHEN user_lesson_catalog_progress.started_at IS NULL THEN now()
                        ELSE user_lesson_catalog_progress.started_at
                    END
                """, userId, lessonNumber);
 
        return Map.of("ok", true, "status", "IN_PROGRESS");
    }
 
    @PostMapping("/{lessonNumber}/submit")
    public Map<String, Object> submitLesson(
            @PathVariable int lessonNumber,
            @RequestBody Map<String, Object> body) {
 
        String userId = (String) body.get("userId");
        int correct = toInt(body.get("correct"), 0);
        int total = toInt(body.get("total"), 10);
        if (userId == null)
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId required");
 
        double scorePct = total > 0 ? (correct * 100.0 / total) : 0;
        boolean passed = scorePct >= 70.0;
        int xpEarned = passed ? 100 : 0;
 
        jdbc.update("""
                INSERT INTO user_lesson_catalog_progress
                    (user_id, lesson_number, status, score_percentage, xp_earned, attempts, passed, completed_at)
                VALUES (?::uuid, ?, ?, ?, ?, 1, ?, CASE WHEN ? THEN now() ELSE NULL END)
                ON CONFLICT (user_id, lesson_number) DO UPDATE SET
                    status = ?,
                    score_percentage = GREATEST(
                        COALESCE(user_lesson_catalog_progress.score_percentage, 0), ?
                    ),
                    xp_earned = CASE WHEN ? AND NOT user_lesson_catalog_progress.passed
                        THEN ? ELSE user_lesson_catalog_progress.xp_earned END,
                    attempts = user_lesson_catalog_progress.attempts + 1,
                    passed = user_lesson_catalog_progress.passed OR ?,
                    completed_at = CASE WHEN ? THEN COALESCE(user_lesson_catalog_progress.completed_at, now())
                        ELSE user_lesson_catalog_progress.completed_at END
                """,
                userId, lessonNumber,
                passed ? "COMPLETED" : "IN_PROGRESS",
                scorePct, xpEarned, passed, passed,
                passed ? "COMPLETED" : "IN_PROGRESS",
                scorePct,
                passed, xpEarned,
                passed,
                passed);
 
        if (passed) {
            jdbc.update("""
                    UPDATE users SET
                        xp = COALESCE(xp, 0) + ?,
                        updated_at = now()
                    WHERE id = ?::uuid
                    """, xpEarned, userId);
 
            jdbc.update("""
                    INSERT INTO xp_history (user_id, amount, source, earned_at)
                    VALUES (?::uuid, ?, 'LESSON', now())
                    """, userId, xpEarned);
 
            if (lessonNumber < 7) {
                jdbc.update("""
                        INSERT INTO user_lesson_catalog_progress
                            (user_id, lesson_number, status)
                        VALUES (?::uuid, ?, 'AVAILABLE')
                        ON CONFLICT (user_id, lesson_number) DO UPDATE SET
                            status = CASE
                                WHEN user_lesson_catalog_progress.status = 'LOCKED' THEN 'AVAILABLE'
                                ELSE user_lesson_catalog_progress.status
                            END
                        """, userId, lessonNumber + 1);
            }
 
            updateStreak(userId);
            updateUserSkills(userId);
 
            // Check if user should level up
            List<Map<String, Object>> userXpRows = jdbc.queryForList(
                "SELECT xp, assigned_level FROM users WHERE id = ?::uuid", userId);
            if (!userXpRows.isEmpty()) {
                int totalXp = toInt(userXpRows.get(0).get("xp"), 0);
                String currentLevel = (String) userXpRows.get(0).get("assigned_level");
 
                if (totalXp >= 10000 && "BEGINNER".equals(currentLevel)) {
                    jdbc.update(
                        "UPDATE users SET assigned_level = 'INTERMEDIATE', updated_at = now() WHERE id = ?::uuid",
                        userId);
                } else if (totalXp >= 25000 && "INTERMEDIATE".equals(currentLevel)) {
                    jdbc.update(
                        "UPDATE users SET assigned_level = 'UPPER_INTERMEDIATE', updated_at = now() WHERE id = ?::uuid",
                        userId);
                } else if (totalXp >= 50000 && "UPPER_INTERMEDIATE".equals(currentLevel)) {
                    jdbc.update(
                        "UPDATE users SET assigned_level = 'ADVANCED', updated_at = now() WHERE id = ?::uuid",
                        userId);
                }
            }
        }
 
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> wrongAnswers = (List<Map<String, Object>>) body.getOrDefault("wrongAnswers",
                List.of());
        for (Map<String, Object> wa : wrongAnswers) {
            logTroubleItem(userId, wa);
        }
 
        Map<String, Object> response = new HashMap<>();
        response.put("passed", passed);
        response.put("scorePct", scorePct);
        response.put("correct", correct);
        response.put("total", total);
        response.put("xpEarned", xpEarned);
        response.put("nextLessonUnlocked", passed && lessonNumber < 7 ? lessonNumber + 1 : null);
        return response;
    }
 
    private List<Map<String, Object>> loadContentForLesson(
            int lessonNumber, String level, String language) {
 
        List<Map<String, Object>> rows;
 
        switch (lessonNumber) {
            case 1:
                rows = jdbc.queryForList("""
                        SELECT id, letter, phonetic_es, phonetic_en, level, lesson_number
                        FROM alphabet
                        WHERE level = ?
                        ORDER BY id ASC
                        """, level);
                break;
 
            case 2:
                rows = jdbc.queryForList("""
                        SELECT id, word, language, translation, part_of_speech,
                               topic_tag, level, example_sentence, example_translation,
                               audio_text, image_keyword, gender, phonetic_guide
                        FROM vocabulary
                        WHERE level = ? AND language = ?
                        ORDER BY frequency_rank ASC NULLS LAST
                        LIMIT 30
                        """, level, language);
                break;
 
            case 3:
                rows = jdbc.queryForList("""
                        SELECT ss.id, ss.spanish, ss.english, ss.level, ss.display_order,
                               COALESCE(
                                   json_agg(
                                       json_build_object(
                                           'id', sw.id,
                                           'word', sw.word,
                                           'grammar_role', sw.grammar_role,
                                           'translation', sw.translation,
                                           'grammar_note', sw.grammar_note,
                                           'display_order', sw.display_order
                                       ) ORDER BY sw.display_order
                                   ) FILTER (WHERE sw.id IS NOT NULL),
                                   '[]'
                               ) as words
                        FROM sentence_structure ss
                        LEFT JOIN sentence_words sw ON sw.sentence_id = ss.id
                        WHERE ss.level = ?
                        GROUP BY ss.id, ss.spanish, ss.english, ss.level, ss.display_order
                        ORDER BY ss.display_order ASC
                        """, level);
                normalizer.normalizeRows(rows);
                return rows;
 
            case 4:
                rows = jdbc.queryForList("""
                        SELECT id, language, phrase, translation, phonetic_guide,
                               context, level, topic_tag, formality, audio_text
                        FROM phrases
                        WHERE level = ? AND language = ?
                        ORDER BY topic_tag ASC, level ASC
                        LIMIT 40
                        """, level, language);
                break;
 
            case 5:
                List<Map<String, Object>> numbers = jdbc.queryForList("""
                        SELECT id, spanish, english, numeral, number_type, level
                        FROM numbers
                        WHERE level = ?
                        ORDER BY id ASC
                        """, level);
                List<Map<String, Object>> timeExpressions = jdbc.queryForList("""
                        SELECT id, spanish, english, category, level
                        FROM time_expressions
                        WHERE level = ?
                        ORDER BY id ASC
                        """, level);
                numbers.forEach(r -> r.put("content_type", "number"));
                timeExpressions.forEach(r -> r.put("content_type", "time"));
                rows = new ArrayList<>();
                rows.addAll(numbers);
                rows.addAll(timeExpressions);
                break;
 
            case 6:
                rows = jdbc.queryForList("""
                        SELECT id, spanish, english, category, level
                        FROM colors_descriptions
                        WHERE level = ?
                        ORDER BY category ASC, id ASC
                        """, level);
                break;
 
            case 7:
                rows = jdbc.queryForList("""
                        SELECT id, spanish, english, category, level
                        FROM family_relationships
                        WHERE level = ?
                        ORDER BY category ASC, id ASC
                        """, level);
                break;
 
            default:
                rows = List.of();
                break;
        }
 
        normalizer.normalizeRows(rows);
        return rows;
    }
 
    private void updateStreak(String userId) {
        List<Map<String, Object>> userRows = jdbc.queryForList(
                "SELECT streak_count, last_active_date FROM users WHERE id = ?::uuid", userId);
        if (userRows.isEmpty())
            return;
 
        Object lastActiveObj = userRows.get(0).get("last_active_date");
        int currentStreak = toInt(userRows.get(0).get("streak_count"), 0);
        LocalDate today = LocalDate.now();
        LocalDate lastActive = lastActiveObj != null
                ? LocalDate.parse(lastActiveObj.toString())
                : null;
 
        int newStreak = currentStreak;
        if (!today.equals(lastActive)) {
            LocalDate yesterday = today.minusDays(1);
            newStreak = yesterday.equals(lastActive) ? currentStreak + 1 : 1;
        }
 
        jdbc.update("""
                UPDATE users SET streak_count = ?, last_active_date = ?, updated_at = now()
                WHERE id = ?::uuid
                """, newStreak, today, userId);
 
        jdbc.update("""
                INSERT INTO streak_history (user_id, streak_date, was_active)
                VALUES (?::uuid, ?, true)
                ON CONFLICT DO NOTHING
                """, userId, today);
    }
 
    private void updateUserSkills(String userId) {
        List<Map<String, Object>> userRows = jdbc.queryForList(
                "SELECT learning_language FROM users WHERE id = ?::uuid", userId);
        if (userRows.isEmpty())
            return;
        String lang = (String) userRows.get(0).get("learning_language");
 
        jdbc.update("""
                INSERT INTO user_skills (user_id, language, lessons_completed, updated_at)
                VALUES (?::uuid, ?, 1, now())
                ON CONFLICT (user_id, language) DO UPDATE SET
                    lessons_completed = user_skills.lessons_completed + 1,
                    updated_at = now()
                """, userId, lang);
    }
 
    private void logTroubleItem(String userId, Map<String, Object> wa) {
        try {
            String language = (String) wa.getOrDefault("language", "es");
            String section = (String) wa.getOrDefault("section", "vocabulary");
            String labelSnapshot = (String) wa.getOrDefault("label", "");
            String referenceType = switch (String.valueOf(section).toLowerCase()) {
                case "grammar" -> "GRAMMAR";
                case "listening" -> "PHRASE";
                case "conversation", "speaking" -> "TEMPLATE";
                case "writing" -> "READING";
                default -> "VOCABULARY";
            };
            String dedupeKey = section + ":" + labelSnapshot;
 
            jdbc.update("""
                    INSERT INTO user_trouble_items
                        (user_id, language, section, reference_type, label_snapshot, dedupe_key, wrong_count, last_wrong_at)
                    VALUES (?::uuid, ?, ?, ?, ?, ?, 1, now())
                    ON CONFLICT (user_id, language, dedupe_key) DO UPDATE SET
                        wrong_count = user_trouble_items.wrong_count + 1,
                        last_wrong_at = now(),
                        section = EXCLUDED.section,
                        reference_type = EXCLUDED.reference_type,
                        label_snapshot = COALESCE(EXCLUDED.label_snapshot, user_trouble_items.label_snapshot)
                    """, userId, language, section, referenceType, labelSnapshot, dedupeKey);
        } catch (Exception ignored) {
        }
    }
 
    private int toInt(Object val, int def) {
        if (val == null)
            return def;
        try {
            return ((Number) val).intValue();
        } catch (Exception e) {
            return def;
        }
    }
}