package com.fluentia.repositories;

import com.fluentia.models.WordRelationship;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface WordRelationshipRepository extends JpaRepository<WordRelationship, UUID> {
}
