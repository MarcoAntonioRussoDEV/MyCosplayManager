package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.ProjectMaterial;

public record ProjectMaterialResponse(
        UUID id,
        CategoryResponse category,
        ProductResponse product,
        UUID inventoryItemId,
        String note,
        BigDecimal quantity,
        String unit,
        BigDecimal price) {

    public static ProjectMaterialResponse from(ProjectMaterial material) {
        return new ProjectMaterialResponse(
                material.getId(),
                material.getCategory() != null ? CategoryResponse.from(material.getCategory()) : null,
                material.getProduct() != null ? ProductResponse.from(material.getProduct()) : null,
                material.getInventoryItem() != null ? material.getInventoryItem().getId() : null,
                material.getNote(),
                material.getQuantity(),
                material.getUnit(),
                material.getPrice());
    }
}
