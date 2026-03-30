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
@Table(name = "notifications")
@Getter
@Setter
@NoArgsConstructor
public class UserNotification {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    @Column(name = "type", nullable = false)
    private String notificationType;
    private String title;
    @Column(columnDefinition = "text")
    private String body;
    private Boolean isRead;
    private Instant scheduledAt;
    private Instant deliveredAt;
    private String deliveryStatus;
    private String channel;
    private Integer retryCount;
    private Instant expiresAt;
    private Instant sentAt;

}
