package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mycosplaymanager.backend.entity.Project;

public interface ProjectRepository extends JpaRepository<Project, UUID> {

    List<Project> findByTeamIdOrderByCreatedAtDesc(UUID teamId);
}
