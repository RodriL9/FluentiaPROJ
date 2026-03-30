package com.fluentia.models;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.UUID;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
public class LessonCulturalNoteId implements Serializable {
    @Column(name = "lesson_id")
    private UUID lessonId;
    @Column(name = "cultural_note_id")
    private UUID culturalNoteId;
}
