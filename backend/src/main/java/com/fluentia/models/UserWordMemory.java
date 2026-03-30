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
@Table(name = "user_word_memory")
@Getter
@Setter
@NoArgsConstructor
public class UserWordMemory {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private UUID vocabularyId;
    private Integer timesSeen;
    private Integer timesCorrect;
    private Integer timesIncorrect;
    private Instant lastSeenAt;
    private Instant nextReviewAt;
    private BigDecimal easeFactor;
    private Integer intervalDays;
    private String memoryStrength;
    @Column(columnDefinition = "text")
    private String lastAnswer;
    private Boolean lastWasCorrect;
    private Instant createdAt;
    private Instant updatedAt;

}
