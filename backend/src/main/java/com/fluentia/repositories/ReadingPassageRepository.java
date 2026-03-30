package com.fluentia.repositories;

import com.fluentia.models.ReadingPassage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ReadingPassageRepository extends JpaRepository<ReadingPassage, UUID> {
}
