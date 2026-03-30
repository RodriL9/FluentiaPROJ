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
@Table(name = "user_mistake_patterns")
@Getter
@Setter
@NoArgsConstructor
public class UserMistakePattern {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private String mistakeType;
    private UUID grammarRuleId;
    private UUID vocabularyId;
    private Integer mistakeCount;
    private Integer resolvedCount;
    private Instant lastMadeAt;
    @Column(columnDefinition = "text")
    private String lastExampleWrong;
    @Column(columnDefinition = "text")
    private String lastExampleCorrect;
    private Boolean scheduledReview;

}
