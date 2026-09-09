package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;

import jakarta.validation.constraints.NotBlank;

public record UpdateProjectRequest(
        @NotBlank String name, String description, String imageUrl,
        BigDecimal laborHours, BigDecimal laborRatePerHour) {
}
