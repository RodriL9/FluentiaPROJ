package com.fluentia.repositories;

import com.fluentia.models.PlacementTest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface PlacementTestRepository extends JpaRepository<PlacementTest, UUID> {
}
