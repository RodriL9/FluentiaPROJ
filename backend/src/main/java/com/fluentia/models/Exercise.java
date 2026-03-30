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
@Table(name = "exercises")
@Getter
@Setter
@NoArgsConstructor
public class Exercise {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID lessonId;
    private String exerciseType;
    @Column(columnDefinition = "text")
    private String prompt;
    @Column(columnDefinition = "text")
    private String correctAnswer;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode options;
    @Column(columnDefinition = "text")
    private String audioText;
    @Column(columnDefinition = "text")
    private String hint;
    private Integer displayOrder;
    private UUID grammarRuleId;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> vocabularyIds;
    private String skillTested;
    private String skill;
    private String difficulty;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode acceptedAnswers;
    private String phoneticGuide;
    private String speechRate;
    private String accent;
    private String distractorLogic;
    private BigDecimal minSimilarityScore;

}
