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
@Table(name = "cultural_notes")
@Getter
@Setter
@NoArgsConstructor
public class CulturalNote {

    @Id
    @GeneratedValue
    private UUID id;
    private String language;
    private String title;
    @Column(columnDefinition = "text")
    private String body;
    private String level;
    private String topicTag;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode relatedWords;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "uuid[]")
    private List<UUID> relatedWordIds;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> countryContext;
    private Integer displayOrder;
    private Instant createdAt;

}
