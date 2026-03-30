package com.fluentia.repositories;

import com.fluentia.models.PlacementAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface PlacementAnswerRepository extends JpaRepository<PlacementAnswer, UUID> {
}
