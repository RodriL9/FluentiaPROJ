package com.fluentia.repositories;

import com.fluentia.models.LevelChangeHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface LevelChangeHistoryRepository extends JpaRepository<LevelChangeHistory, UUID> {
}
