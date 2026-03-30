package com.fluentia.repositories;

import com.fluentia.models.PersonalizedLessonQueue;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface PersonalizedLessonQueueRepository extends JpaRepository<PersonalizedLessonQueue, UUID> {
}
