package com.fluentia.repositories;

import com.fluentia.models.UserAchievement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserAchievementRepository extends JpaRepository<UserAchievement, UUID> {
}
