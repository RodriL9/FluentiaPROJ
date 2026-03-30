package com.fluentia.repositories;

import com.fluentia.models.UserMistakePattern;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserMistakePatternRepository extends JpaRepository<UserMistakePattern, UUID> {
}
