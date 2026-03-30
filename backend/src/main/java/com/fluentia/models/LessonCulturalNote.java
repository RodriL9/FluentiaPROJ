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
@Table(name = "lesson_cultural_notes")
@Getter
@Setter
@NoArgsConstructor
public class LessonCulturalNote {

    @EmbeddedId
    private LessonCulturalNoteId id;
    private Integer showAfterExercise;

}
