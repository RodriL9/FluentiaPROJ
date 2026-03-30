package com.fluentia.repositories;

import com.fluentia.models.UserWordMemory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface UserWordMemoryRepository extends JpaRepository<UserWordMemory, UUID> {
}
