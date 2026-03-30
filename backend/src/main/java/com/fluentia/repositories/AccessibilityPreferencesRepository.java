package com.fluentia.repositories;

import com.fluentia.models.AccessibilityPreferences;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface AccessibilityPreferencesRepository extends JpaRepository<AccessibilityPreferences, UUID> {
}
