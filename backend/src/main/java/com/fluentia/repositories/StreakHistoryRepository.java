package com.fluentia.repositories;

import com.fluentia.models.StreakHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface StreakHistoryRepository extends JpaRepository<StreakHistory, UUID> {
}
