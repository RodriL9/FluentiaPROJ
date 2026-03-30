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
@Table(name = "system_performance_log")
@Getter
@Setter
@NoArgsConstructor
public class SystemPerformanceLog {

    @Id
    @GeneratedValue
    private UUID id;
    private String endpoint;
    private String method;
    private Integer responseMs;
    private Integer statusCode;
    private UUID userId;
    private Integer thresholdMs;
    private Boolean exceededThreshold;
    private Instant loggedAt;

}
