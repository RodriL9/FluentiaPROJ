package com.fluentia.repositories;

import com.fluentia.models.UserLessonProgress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserLessonProgressRepository extends JpaRepository<UserLessonProgress, UUID> {
}
