package com.fluentia.repositories;

import com.fluentia.models.XpHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface XpHistoryRepository extends JpaRepository<XpHistory, UUID> {
}
