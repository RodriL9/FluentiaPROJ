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
@Table(name = "user_learning_preferences")
@Getter
@Setter
@NoArgsConstructor
public class UserLearningPreferences {

    @Id
    @Column(name = "user_id")
    private UUID userId;
    private Integer dailyGoalXp;
    private Integer sessionLengthMinutes;
    @JdbcTypeCode(SqlTypes.ARRAY)
    @Column(columnDefinition = "text[]")
    private List<String> preferredExerciseTypes;
    private Boolean weakSkillsFocus;
    private Boolean spacedRepetitionOn;
    private Boolean showCulturalNotes;
    private Boolean showPhoneticGuides;
    private String accentPreference;
    private LocalTime reminderTime;
    private Instant updatedAt;

}
