package com.fluentia.repositories;

import com.fluentia.models.UserTopic;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.fluentia.models.UserTopicId;

@Repository
public interface UserTopicRepository extends JpaRepository<UserTopic, UserTopicId> {
}
