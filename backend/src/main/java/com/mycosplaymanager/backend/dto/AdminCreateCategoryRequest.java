package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.NotBlank;

public record AdminCreateCategoryRequest(
        @NotBlank String code, @NotBlank String nameIt, @NotBlank String nameEn,
        @NotBlank String nameEs, @NotBlank String nameFr) {
}
