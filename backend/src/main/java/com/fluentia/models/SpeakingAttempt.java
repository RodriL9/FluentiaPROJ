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
@Table(name = "speaking_attempts")
@Getter
@Setter
@NoArgsConstructor
public class SpeakingAttempt {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private UUID exerciseId;
    @Column(columnDefinition = "text")
    private String targetPhrase;
    @Column(columnDefinition = "text")
    private String transcribedText;
    private BigDecimal similarityScore;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode phonemeErrors;
    private Boolean passed;
    private Integer audioDurationMs;
    private Instant attemptedAt;

}
