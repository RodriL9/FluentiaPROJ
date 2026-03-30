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
@Table(name = "common_mistakes")
@Getter
@Setter
@NoArgsConstructor
public class CommonMistake {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID userId;
    private String mistakeType;
    private UUID referenceId;
    private Integer mistakeCount;
    private Instant lastMadeAt;
    @Column(columnDefinition = "text")
    private String exampleWrong;
    @Column(columnDefinition = "text")
    private String exampleCorrect;
    private Instant createdAt;

}
