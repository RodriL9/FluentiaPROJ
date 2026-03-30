package com.fluentia.repositories;

import com.fluentia.models.DashboardMetric;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface DashboardMetricRepository extends JpaRepository<DashboardMetric, UUID> {
}
