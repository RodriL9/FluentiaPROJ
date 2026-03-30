package com.fluentia.repositories;

import com.fluentia.models.LessonNavigationLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LessonNavigationLogRepository extends JpaRepository<LessonNavigationLog, UUID> {
}
