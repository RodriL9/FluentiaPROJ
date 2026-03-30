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
@Table(name = "lessons")
@Getter
@Setter
@NoArgsConstructor
public class Lesson {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID unitId;
    private String title;
    private Integer lessonNumber;
    private Integer totalLessonsInUnit;
    private Integer xpReward;
    private Integer displayOrder;
    private String lessonType;
    private UUID grammarRuleId;
    private UUID readingPassageId;
    private Integer estimatedMinutes;
    private UUID prerequisiteLessonId;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode unlockCondition;

}
