package com.cosplayinventory.backend.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;

public record CreateProductRequest(
        @NotBlank String barcode,
        @NotBlank String name,
        String brand,
        UUID categoryId,
        String imageUrl,
        Integer daysAfterOpening) {
}
