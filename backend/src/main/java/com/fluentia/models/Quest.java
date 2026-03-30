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
@Table(name = "quests")
@Getter
@Setter
@NoArgsConstructor
public class Quest {

    @Id
    @GeneratedValue
    private UUID id;
    private String code;
    private String title;
    private String icon;
    private Integer targetValue;
    private Integer xpReward;

}
