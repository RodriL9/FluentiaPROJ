package com.fluentia.repositories;

import com.fluentia.models.Conjugation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ConjugationRepository extends JpaRepository<Conjugation, UUID> {
}
