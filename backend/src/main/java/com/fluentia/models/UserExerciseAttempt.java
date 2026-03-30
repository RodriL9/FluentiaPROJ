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
@Table(name = "user_exercise_attempts")
@Getter
@Setter
@NoArgsConstructor
public class UserExerciseAttempt {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private UUID exerciseId;
    @Column(columnDefinition = "text")
    private String userAnswer;
    private Boolean isCorrect;
    private Instant attemptedAt;

}
