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
@Table(name = "ai_conversation_templates")
@Getter
@Setter
@NoArgsConstructor
public class AiConversationTemplate {

    @Id
    @GeneratedValue
    private UUID id;
    private String language;
    private String title;
    @Column(columnDefinition = "text")
    private String scenario;
    private String topicTag;
    private String level;
    @Column(columnDefinition = "text")
    private String openingPrompt;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> targetVocabulary;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> targetGrammarRules;
    private Integer minExchanges;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode evaluationCriteria;

}
