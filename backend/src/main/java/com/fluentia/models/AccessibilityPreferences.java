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
@Table(name = "accessibility_preferences")
@Getter
@Setter
@NoArgsConstructor
public class AccessibilityPreferences {

    @Id
    @Column(name = "user_id")
    private UUID userId;
    private Boolean highContrastMode;
    private String fontSize;
    private Boolean reducedMotion;
    private Boolean screenReaderMode;
    private String colorBlindMode;
    private Boolean audioDescriptions;
    private Boolean keyboardNavOnly;
    private Instant updatedAt;

}
