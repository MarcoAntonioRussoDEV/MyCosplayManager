package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.mycosplaymanager.backend.entity.ProjectMaterial;

public interface ProjectMaterialRepository extends JpaRepository<ProjectMaterial, UUID> {

    // LEFT JOIN FETCH product/category (facoltativi)/project: letti nel DTO fuori transazione (open-in-view: false).
    @Query("SELECT m FROM ProjectMaterial m LEFT JOIN FETCH m.product p LEFT JOIN FETCH p.category "
            + "LEFT JOIN FETCH m.category JOIN FETCH m.project WHERE m.project.id = :projectId ORDER BY m.createdAt")
    List<ProjectMaterial> findByProjectIdWithProduct(@Param("projectId") UUID projectId);

    @Query("SELECT m FROM ProjectMaterial m LEFT JOIN FETCH m.product p LEFT JOIN FETCH p.category "
            + "LEFT JOIN FETCH m.category JOIN FETCH m.project WHERE m.id = :id")
    Optional<ProjectMaterial> findWithProductAndProjectById(@Param("id") UUID id);
}
