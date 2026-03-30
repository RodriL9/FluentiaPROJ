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
@Table(name = "units")
@Getter
@Setter
@NoArgsConstructor
public class Unit {

    @Id
    @GeneratedValue
    private UUID id;
    private UUID sectionId;
    private String title;
    @Column(columnDefinition = "text")
    private String description;
    private String topicCode;
    private Integer displayOrder;

}
