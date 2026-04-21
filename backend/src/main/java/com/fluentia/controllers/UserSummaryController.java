package com.fluentia.controllers;

import com.fluentia.config.JdbcJsonNormalizer;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

@RestController
public class UserSummaryController {

        private final JdbcTemplate jdbc;
        private final JdbcJsonNormalizer normalizer;

        public UserSummaryController(JdbcTemplate jdbc, JdbcJsonNormalizer normalizer) {
                this.jdbc = jdbc;
                this.normalizer = normalizer;
        }

        @GetMapping("/me/summary")
        public Map<String, Object> meSummary(@RequestParam String userId) {

                List<Map<String, Object>> userRows = jdbc.queryForList(
                                "SELECT xp, streak_count, last_active_date, assigned_level, " +
                                                "learning_language, native_language, full_name, username, learning_goals "
                                                +
                                                "FROM users WHERE id = ?::uuid",
                                userId);

                if (userRows.isEmpty())
                        return Map.of("xp", 0, "streak_count", 0);
                Map<String, Object> user = userRows.get(0);

                List<Map<String, Object>> coreLessons = jdbc.queryForList(
                                "SELECT lc.lesson_number, lc.title, " +
                                                "COALESCE(ulcp.status, 'LOCKED') as status, " +
                                                "COALESCE(ulcp.passed, false) as passed, " +
                                                "COALESCE(ulcp.xp_earned, 0) as xp_earned, ulcp.completed_at " +
                                                "FROM lesson_catalog lc " +
                                                "LEFT JOIN user_lesson_catalog_progress ulcp " +
                                                "ON ulcp.lesson_number = lc.lesson_number AND ulcp.user_id = ?::uuid " +
                                                "ORDER BY lc.lesson_number ASC",
                                userId);

                List<Map<String, Object>> recentActivity = jdbc.queryForList(
                                "SELECT 'Core Lesson' as type, lc.title as lesson_title, ulcp.xp_earned, ulcp.completed_at "
                                                +
                                                "FROM user_lesson_catalog_progress ulcp " +
                                                "JOIN lesson_catalog lc ON lc.lesson_number = ulcp.lesson_number " +
                                                "WHERE ulcp.user_id = ?::uuid AND ulcp.passed = true " +
                                                "UNION ALL " +
                                                "SELECT 'Topic Lesson', l.title, ulp.xp_earned, ulp.completed_at " +
                                                "FROM user_lesson_progress ulp " +
                                                "JOIN lessons l ON ulp.lesson_id = l.id " +
                                                "WHERE ulp.user_id = ?::uuid AND ulp.status = 'COMPLETED' " +
                                                "ORDER BY completed_at DESC NULLS LAST LIMIT 5",
                                userId, userId);

                int coreCompleted = (int) coreLessons.stream()
                                .filter(l -> Boolean.TRUE.equals(l.get("passed"))).count();

                List<Map<String, Object>> topicCompletedRows = jdbc.queryForList(
                                "SELECT COUNT(*) as cnt FROM user_lesson_progress WHERE user_id = ?::uuid AND status = 'COMPLETED'",
                                userId);
                int topicCompleted = toInt(topicCompletedRows.get(0).get("cnt"), 0);

                List<Map<String, Object>> skillRows = jdbc.queryForList(
                                "SELECT vocabulary_score, grammar_score, listening_score, writing_score, speaking_score, lessons_completed "
                                                +
                                                "FROM user_skills WHERE user_id = ?::uuid AND language = ?",
                                userId, user.get("learning_language"));

                List<Map<String, Object>> weakSpotCount = jdbc.queryForList(
                                "SELECT COUNT(*) as cnt FROM user_trouble_items WHERE user_id = ?::uuid", userId);

                Map<String, Object> result = new HashMap<>(user);
                result.put("coreLessonsCompleted", coreCompleted);
                result.put("coreLessonsTotal", 7);
                result.put("topicLessonsCompleted", topicCompleted);
                result.put("coreLessons", coreLessons);
                result.put("recentActivity", recentActivity);
                result.put("skills", skillRows.isEmpty() ? null : skillRows.get(0));
                result.put("weakSpotsCount", toInt(weakSpotCount.get(0).get("cnt"), 0));

                return result;
        }

        @PostMapping("/me/topics/add")
        public Map<String, Object> addTopic(@RequestBody Map<String, Object> body) {
                String userId = (String) body.get("userId");
                String topicCode = (String) body.get("topicCode");
                if (userId == null || topicCode == null) {
                        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "userId and topicCode required");
                }

                List<Map<String, Object>> userRows = jdbc.queryForList(
                                "SELECT learning_goals FROM users WHERE id = ?::uuid", userId);
                if (userRows.isEmpty())
                        return Map.of("ok", false);

                String existing = (String) userRows.get(0).get("learning_goals");
                String updated;
                if (existing == null || existing.isBlank()) {
                        updated = topicCode;
                } else if (existing.contains(topicCode)) {
                        return Map.of("ok", true, "learning_goals", existing);
                } else {
                        updated = existing + "," + topicCode;
                }

                jdbc.update("UPDATE users SET learning_goals = ?, updated_at = now() WHERE id = ?::uuid",
                                updated, userId);

                return Map.of("ok", true, "learning_goals", updated);
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