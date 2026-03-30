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
@Table(name = "lesson_versions")
@Getter
@Setter
@NoArgsConstructor
public class LessonVersion {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID lessonId;
    private Integer versionNumber;
    private UUID changedBy;
    @Column(columnDefinition = "text")
    private String changeSummary;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode snapshot;
    private Instant createdAt;

}
