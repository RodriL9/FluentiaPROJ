package com.fluentia.repositories;

import com.fluentia.models.UserLearningPreferences;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserLearningPreferencesRepository extends JpaRepository<UserLearningPreferences, UUID> {
}
