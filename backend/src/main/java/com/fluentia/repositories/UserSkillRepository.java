package com.fluentia.repositories;

import com.fluentia.models.UserSkill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserSkillRepository extends JpaRepository<UserSkill, UUID> {
}
