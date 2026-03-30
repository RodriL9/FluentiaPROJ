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
@Table(name = "subscriptions")
@Getter
@Setter
@NoArgsConstructor
public class Subscription {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String plan;
    private String status;
    private Instant startedAt;
    private Instant expiresAt;
    private String paymentReference;
    private String transactionId;
    private String paymentGateway;
    private String paymentMethod;
    private String paymentStatus;
    private Instant trialStartDate;
    private Instant trialEndDate;
    private Boolean autoRenew;
    @Column(columnDefinition = "text")
    private String cancellationReason;
    private Instant lastPaymentAt;
    private Instant nextBillingDate;
    private BigDecimal amountPaid;
    private String currency;
    private Instant cancelledAt;

}
