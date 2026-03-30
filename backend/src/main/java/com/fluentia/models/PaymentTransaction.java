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
@Table(name = "payment_transactions")
@Getter
@Setter
@NoArgsConstructor
public class PaymentTransaction {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private UUID subscriptionId;
    private String transactionRef;
    private String gateway;
    private BigDecimal amount;
    private String currency;
    private String status;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode gatewayResponse;
    @Column(columnDefinition = "text")
    private String failureReason;
    private Instant initiatedAt;
    private Instant completedAt;
    private Instant timeoutAt;
    private String ipAddress;
    private Boolean isEncrypted;

}
