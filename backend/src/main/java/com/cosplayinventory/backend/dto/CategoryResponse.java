package com.cosplayinventory.backend.dto;

import java.util.UUID;

import com.cosplayinventory.backend.entity.Category;

public record CategoryResponse(UUID id, String code, String nameIt, String nameEn, String nameEs, String nameFr) {

    public static CategoryResponse from(Category category) {
        return new CategoryResponse(
                category.getId(), category.getCode(),
                category.getNameIt(), category.getNameEn(), category.getNameEs(), category.getNameFr());
    }
}
