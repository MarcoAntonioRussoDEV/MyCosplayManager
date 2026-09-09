package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UpdateProjectMaterialRequest(
        @NotNull BigDecimal quantity, @NotBlank String unit, BigDecimal price, String note) {
}
