package com.fluentia.repositories;

import com.fluentia.models.AdminLevelAdjustment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface AdminLevelAdjustmentRepository extends JpaRepository<AdminLevelAdjustment, UUID> {
}
