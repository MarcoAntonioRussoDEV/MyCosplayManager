package com.mycosplaymanager.backend.dto;

import java.time.Instant;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.AdminEmail;

public record AdminEmailResponse(UUID id, String email, Instant createdAt) {

    public static AdminEmailResponse from(AdminEmail adminEmail) {
        return new AdminEmailResponse(adminEmail.getId(), adminEmail.getEmail(), adminEmail.getCreatedAt());
    }
}
