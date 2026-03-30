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
@Table(name = "grammar_rules")
@Getter
@Setter
@NoArgsConstructor
public class GrammarRule {

    @Id
    @GeneratedValue
    private UUID id;
    private String code;
    private String language;
    private String title;
    @Column(columnDefinition = "text")
    private String explanation;
    private String level;
    private String category;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode examples;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode commonMistakes;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> relatedRuleCodes;
    private Integer displayOrder;
    private Instant createdAt;

}
