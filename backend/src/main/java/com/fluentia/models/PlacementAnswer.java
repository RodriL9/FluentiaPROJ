package com.fluentia.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;

@Entity
@Table(name = "placement_answers")
@Getter
@Setter
@NoArgsConstructor
public class PlacementAnswer {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;
    private UUID testId;
    private Integer questionIndex;
    private String questionType;
    @Column(columnDefinition = "text")
    private String userAnswer;
    @Column(columnDefinition = "text")
    private String correctAnswer;
    private Boolean isCorrect;

}
