package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.Project;

public record ProjectResponse(
        UUID id, String name, String description, String imageUrl,
        BigDecimal laborHours, BigDecimal laborRatePerHour, Instant createdAt) {

    public static ProjectResponse from(Project project) {
        return new ProjectResponse(
                project.getId(), project.getName(), project.getDescription(), project.getImageUrl(),
                project.getLaborHours(), project.getLaborRatePerHour(), project.getCreatedAt());
    }
}
