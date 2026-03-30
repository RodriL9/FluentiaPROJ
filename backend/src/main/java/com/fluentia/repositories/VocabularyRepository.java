package com.fluentia.repositories;

import com.fluentia.models.Vocabulary;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface VocabularyRepository extends JpaRepository<Vocabulary, UUID> {
}
