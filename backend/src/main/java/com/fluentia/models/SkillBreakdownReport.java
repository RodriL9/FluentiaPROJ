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
@Table(name = "skill_breakdown_reports")
@Getter
@Setter
@NoArgsConstructor
public class SkillBreakdownReport {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private LocalDate reportDate;
    private BigDecimal vocabularyScore;
    private BigDecimal grammarScore;
    private BigDecimal listeningScore;
    private BigDecimal writingScore;
    private BigDecimal speakingScore;
    private BigDecimal overallScore;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> weakAreas;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> strongAreas;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> recommendedFocus;
    private Integer lessonsThisPeriod;
    private Integer xpThisPeriod;
    private Instant generatedAt;

}
