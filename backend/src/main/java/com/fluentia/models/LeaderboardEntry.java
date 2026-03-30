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
@Table(name = "leaderboard_entries")
@Getter
@Setter
@NoArgsConstructor
public class LeaderboardEntry {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private LocalDate weekStart;
    private Integer xpEarned;
    private String league;
    @Column(name = "rank")
    private Integer rank;

}
