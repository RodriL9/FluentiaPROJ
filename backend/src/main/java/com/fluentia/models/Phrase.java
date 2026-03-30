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
@Table(name = "phrases")
@Getter
@Setter
@NoArgsConstructor
public class Phrase {

    @Id
    @GeneratedValue
    private UUID id;
    private String language;
    @Column(columnDefinition = "text")
    private String phrase;
    @Column(columnDefinition = "text")
    private String translation;
    private String phoneticGuide;
    private String context;
    private String level;
    private String topicTag;
    private String formality;
    @Column(columnDefinition = "text")
    private String audioText;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode exampleDialogue;

}
