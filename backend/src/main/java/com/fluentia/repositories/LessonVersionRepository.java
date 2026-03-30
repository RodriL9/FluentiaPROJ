package com.fluentia.repositories;

import com.fluentia.models.LessonVersion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LessonVersionRepository extends JpaRepository<LessonVersion, UUID> {
}
