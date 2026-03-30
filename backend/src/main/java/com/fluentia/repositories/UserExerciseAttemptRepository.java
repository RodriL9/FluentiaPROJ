package com.fluentia.repositories;

import com.fluentia.models.UserExerciseAttempt;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserExerciseAttemptRepository extends JpaRepository<UserExerciseAttempt, UUID> {
}
