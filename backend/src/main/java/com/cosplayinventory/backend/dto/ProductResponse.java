package com.cosplayinventory.backend.dto;

import java.util.UUID;

import com.cosplayinventory.backend.entity.Product;

public record ProductResponse(
        UUID id, String barcode, String name, String brand,
        UUID categoryId, String imageUrl, Integer daysAfterOpening, String source) {

    public static ProductResponse from(Product product) {
        return new ProductResponse(
                product.getId(), product.getBarcode(), product.getName(), product.getBrand(),
                product.getCategory() != null ? product.getCategory().getId() : null,
                product.getImageUrl(), product.getDaysAfterOpening(), product.getSource());
    }
}
