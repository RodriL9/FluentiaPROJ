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
@Table(name = "reading_passages")
@Getter
@Setter
@NoArgsConstructor
public class ReadingPassage {

    @Id
    @GeneratedValue
    private UUID id;
    private String language;
    private String title;
    @Column(columnDefinition = "text")
    private String body;
    @Column(columnDefinition = "text")
    private String translation;
    private String level;
    private String topicTag;
    private Integer wordCount;
    private Integer estimatedMinutes;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> vocabularyIds;
    private Instant createdAt;

}
