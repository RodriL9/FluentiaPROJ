package com.fluentia.repositories;

import com.fluentia.models.ReadingQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ReadingQuestionRepository extends JpaRepository<ReadingQuestion, UUID> {
}
