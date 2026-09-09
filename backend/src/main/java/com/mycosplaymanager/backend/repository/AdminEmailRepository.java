package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mycosplaymanager.backend.entity.AdminEmail;

public interface AdminEmailRepository extends JpaRepository<AdminEmail, UUID> {

    boolean existsByEmailIgnoreCase(String email);

    List<AdminEmail> findAllByOrderByCreatedAtAsc();
}
