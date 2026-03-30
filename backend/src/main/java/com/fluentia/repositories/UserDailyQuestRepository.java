package com.fluentia.repositories;

import com.fluentia.models.UserDailyQuest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserDailyQuestRepository extends JpaRepository<UserDailyQuest, UUID> {
}
