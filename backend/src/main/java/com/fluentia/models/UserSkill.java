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
@Table(name = "user_skills")
@Getter
@Setter
@NoArgsConstructor
public class UserSkill {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private BigDecimal vocabularyScore;
    private BigDecimal grammarScore;
    private BigDecimal listeningScore;
    private BigDecimal writingScore;
    private BigDecimal speakingScore;
    private BigDecimal pronunciationScore;
    private BigDecimal overallScore;
    private Integer lessonsCompleted;
    private Integer exercisesAttempted;
    private Integer exercisesCorrect;
    private Instant updatedAt;

}
