package com.fluentia.repositories;

import com.fluentia.models.ExerciseDistractor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ExerciseDistractorRepository extends JpaRepository<ExerciseDistractor, UUID> {
}
