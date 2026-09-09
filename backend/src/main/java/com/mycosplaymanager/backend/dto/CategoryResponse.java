package com.mycosplaymanager.backend.dto;

import java.util.UUID;

import com.mycosplaymanager.backend.entity.Category;

public record CategoryResponse(UUID id, String code, String nameIt, String nameEn, String nameEs, String nameFr) {

    public static CategoryResponse from(Category category) {
        return new CategoryResponse(
                category.getId(), category.getCode(),
                category.getNameIt(), category.getNameEn(), category.getNameEs(), category.getNameFr());
    }
}
