package com.fluentia.repositories;

import com.fluentia.models.ReviewSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface ReviewSessionRepository extends JpaRepository<ReviewSession, UUID> {
}
