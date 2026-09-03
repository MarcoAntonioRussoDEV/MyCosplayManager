package com.cosplayinventory.backend.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateInventoryItemRequest(
        @NotNull UUID productId,
        @NotNull BigDecimal quantity,
        @NotBlank String unit,
        BigDecimal price,
        String locationText,
        LocalDate expiryDate) {
}
