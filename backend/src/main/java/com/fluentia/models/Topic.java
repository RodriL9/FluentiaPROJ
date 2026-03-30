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
@Table(name = "topics")
@Getter
@Setter
@NoArgsConstructor
public class Topic {

    @Id
    @GeneratedValue
    private UUID id;
    private String code;
    private String name;
    private String icon;
    @Column(columnDefinition = "text")
    private String description;
    private String language;
    private Integer displayOrder;

}
