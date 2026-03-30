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
@Table(name = "milestone_reassessments")
@Getter
@Setter
@NoArgsConstructor
public class MilestoneReassessment {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String language;
    private Instant triggeredAt;
    private String triggerReason;
    private Integer lessonsCompleted;
    private String previousLevel;
    private String newLevel;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode skillSnapshot;
    private String reassessmentType;
    private UUID testId;

}
