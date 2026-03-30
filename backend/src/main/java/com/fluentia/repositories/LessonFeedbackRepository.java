package com.fluentia.repositories;

import com.fluentia.models.LessonFeedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LessonFeedbackRepository extends JpaRepository<LessonFeedback, UUID> {
}
