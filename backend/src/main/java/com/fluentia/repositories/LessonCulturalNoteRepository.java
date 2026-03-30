package com.fluentia.repositories;

import com.fluentia.models.LessonCulturalNote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fluentia.models.LessonCulturalNoteId;

@Repository
public interface LessonCulturalNoteRepository extends JpaRepository<LessonCulturalNote, LessonCulturalNoteId> {
}
