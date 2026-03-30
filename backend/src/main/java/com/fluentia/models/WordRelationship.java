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
@Table(name = "word_relationships")
@Getter
@Setter
@NoArgsConstructor
public class WordRelationship {

    @Id
    @GeneratedValue
    private UUID id;
    @Column(name = "word_id_1")
    private UUID wordId1;
    @Column(name = "word_id_2")
    private UUID wordId2;
    private String relationship;
    @Column(columnDefinition = "text")
    private String notes;
    private Instant createdAt;

}
