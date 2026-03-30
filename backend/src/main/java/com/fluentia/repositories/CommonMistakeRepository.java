package com.fluentia.repositories;

import com.fluentia.models.CommonMistake;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface CommonMistakeRepository extends JpaRepository<CommonMistake, UUID> {
}
