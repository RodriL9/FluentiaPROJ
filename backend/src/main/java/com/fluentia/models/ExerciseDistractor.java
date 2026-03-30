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
@Table(name = "exercise_distractors")
@Getter
@Setter
@NoArgsConstructor
public class ExerciseDistractor {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID vocabularyId;
    private String distractorType;
    @Column(columnDefinition = "text")
    private String distractorValue;
    private String language;
    @Column(columnDefinition = "text")
    private String reason;

}
