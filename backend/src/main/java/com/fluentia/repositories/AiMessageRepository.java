package com.fluentia.repositories;

import com.fluentia.models.AiMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface AiMessageRepository extends JpaRepository<AiMessage, UUID> {
}
