package com.mycosplaymanager.backend.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;

public record AdminUpdateProductRequest(
        @NotBlank String name, String brand, UUID categoryId, Integer daysAfterOpening) {
}
