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
@Table(name = "ai_sessions")
@Getter
@Setter
@NoArgsConstructor
public class AiSession {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private String topic;
    private UUID templateId;
    private String sessionStatus;
    private Boolean fallbackUsed;
    @Column(columnDefinition = "text")
    private String fallbackReason;
    @Column(columnDefinition = "text")
    private String errorMessage;
    private Integer avgResponseMs;
    private Integer speechAttempts;
    private Integer speechFailures;
    private BigDecimal grammarScore;
    private BigDecimal vocabularyScore;
    private BigDecimal fluencyScore;
    @Column(columnDefinition = "text")
    private String feedbackSummary;
    private Instant startedAt;
    private Instant endedAt;
    private Integer totalMessages;
    private Integer xpAwarded;

}
