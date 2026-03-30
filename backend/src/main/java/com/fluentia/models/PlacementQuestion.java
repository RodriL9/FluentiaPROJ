package com.fluentia.models;

import com.fasterxml.jackson.databind.JsonNode;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.util.UUID;

@Entity
@Table(name = "placement_questions")
@Getter
@Setter
@NoArgsConstructor
public class PlacementQuestion {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private String language;
    private Integer questionIndex;
    private String questionType;
    @Column(columnDefinition = "text")
    private String prompt;
    @JdbcTypeCode(SqlTypes.JSON)
    private JsonNode options;
    @Column(columnDefinition = "text")
    private String correctAnswer;
    private String difficulty;
    private String skillTested;
    private Integer nextQuestionIfCorrect;
    private Integer nextQuestionIfWrong;
    private Integer pointsValue;
    private Integer timeLimitSeconds;

}
