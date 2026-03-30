package com.fluentia.models;

import com.fasterxml.jackson.databind.JsonNode;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "user_lesson_progress")
@Getter
@Setter
@NoArgsConstructor
public class UserLessonProgress {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private UUID lessonId;
    private String status;
    private Integer exercisesCorrect;
    private Integer exercisesTotal;
    private BigDecimal scorePercentage;
    private Integer xpEarned;
    private Integer timeSpentSeconds;
    private Integer attempts;
    private Boolean milestoneReached;
    private UUID nextRecommendedLessonId;
    private Instant completedAt;
    private Instant startedAt;

}
