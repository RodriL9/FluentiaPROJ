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
@Table(name = "ai_messages")
@Getter
@Setter
@NoArgsConstructor
public class AiMessage {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID sessionId;
    private String sender;
    @Column(columnDefinition = "text")
    private String content;
    @Column(columnDefinition = "text")
    private String grammarFeedback;
    @Column(columnDefinition = "text")
    private String vocabularyFeedback;
    @Column(columnDefinition = "text")
    private String pronunciationTips;
    private Instant sentAt;

}
