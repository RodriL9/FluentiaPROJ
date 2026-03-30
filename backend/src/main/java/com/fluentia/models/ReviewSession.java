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
@Table(name = "review_sessions")
@Getter
@Setter
@NoArgsConstructor
public class ReviewSession {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private String sessionType;
    private String status;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> wordsDue;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> rulesDue;
    private Integer totalItems;
    private Integer itemsReviewed;
    private Integer itemsCorrect;
    private Integer xpAwarded;
    private Instant createdAt;
    private Instant completedAt;

}
