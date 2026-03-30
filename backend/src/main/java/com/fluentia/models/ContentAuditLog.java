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
@Table(name = "content_audit_log")
@Getter
@Setter
@NoArgsConstructor
public class ContentAuditLog {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID adminId;
    private String action;
    private String targetType;
    private UUID targetId;
    @Column(columnDefinition = "text")
    private String notes;
    private Instant performedAt;

}
