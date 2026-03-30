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
@Table(name = "dashboard_metrics")
@Getter
@Setter
@NoArgsConstructor
public class DashboardMetric {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private Integer totalXp;
    private Integer currentStreak;
    private Integer longestStreak;
    private Integer lessonsCompleted;
    private Integer lessonsInProgress;
    private String currentLevel;
    private Integer xpToNextLevel;
    private Integer xpInCurrentLevel;
    private Integer weeklyXp;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode weeklyXpByDay;
    private BigDecimal skillVocabulary;
    private BigDecimal skillGrammar;
    private BigDecimal skillListening;
    private BigDecimal skillWriting;
    private BigDecimal skillSpeaking;
    private Integer achievementsCount;
    private String currentLeague;
    private Integer leagueRank;
    private Integer aiSessionsCount;
    private Instant lastComputedAt;

}
