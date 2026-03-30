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
import java.util.UUID;

@Entity
@Table(name = "placement_tests")
@Getter
@Setter
@NoArgsConstructor
public class PlacementTest {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private UUID userId;
    private String language;
    private Integer score;
    private Integer totalQuestions;
    private BigDecimal percentageScore;
    private String assignedLevel;
    private Integer durationSeconds;
    private Boolean wasCompleted;
    private String exitReason;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode difficultyPath;
    private UUID recommendedUnitId;
    private Instant takenAt;

}
