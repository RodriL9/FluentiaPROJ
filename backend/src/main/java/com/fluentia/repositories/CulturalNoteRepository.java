package com.fluentia.repositories;

import com.fluentia.models.CulturalNote;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface CulturalNoteRepository extends JpaRepository<CulturalNote, UUID> {
}
