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
@Table(name = "vocabulary")
@Getter
@Setter
@NoArgsConstructor
public class Vocabulary {

    @Id
    @GeneratedValue
    private UUID id;
    private String word;
    private String language;
    private String translation;
    private String transliteration;
    private String partOfSpeech;
    private String topicTag;
    private String level;
    @Column(columnDefinition = "text")
    private String exampleSentence;
    @Column(columnDefinition = "text")
    private String exampleTranslation;
    @Column(columnDefinition = "text")
    private String audioText;
    private String imageKeyword;
    private String gender;
    private String pluralForm;
    private String conjugationGroup;
    private String audioPhonetic;
    private String phoneticGuide;
    private Integer frequencyRank;
    private String accent;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode regionalVariants;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> tags;
    private Boolean isIrregular;
    @Column(columnDefinition = "text")
    private String notes;
    private Instant createdAt;

}
