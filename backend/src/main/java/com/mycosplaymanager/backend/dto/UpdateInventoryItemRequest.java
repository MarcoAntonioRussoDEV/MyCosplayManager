package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UpdateInventoryItemRequest(
        @NotNull BigDecimal quantity,
        @NotBlank String unit,
        BigDecimal price,
        String locationText,
        LocalDate expiryDate,
        BigDecimal remainingQuantity) {
}
