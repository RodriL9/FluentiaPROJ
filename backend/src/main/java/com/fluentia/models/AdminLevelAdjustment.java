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
@Table(name = "admin_level_adjustments")
@Getter
@Setter
@NoArgsConstructor
public class AdminLevelAdjustment {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID adminId;
    private UUID learnerId;
    private String previousLevel;
    private String newLevel;
    private String justification;
    private Instant adjustedAt;

}
