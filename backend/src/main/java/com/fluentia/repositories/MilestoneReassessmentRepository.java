package com.fluentia.repositories;

import com.fluentia.models.MilestoneReassessment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface MilestoneReassessmentRepository extends JpaRepository<MilestoneReassessment, UUID> {
}
