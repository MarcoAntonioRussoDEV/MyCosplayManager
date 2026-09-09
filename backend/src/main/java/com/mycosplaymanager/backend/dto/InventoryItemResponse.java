package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.InventoryItem;

public record InventoryItemResponse(
        UUID id,
        ProductResponse product,
        BigDecimal quantity,
        String unit,
        BigDecimal price,
        String locationText,
        LocalDate expiryDate,
        String status,
        LocalDate openedAt,
        BigDecimal remainingQuantity) {

    public static InventoryItemResponse from(InventoryItem item) {
        return new InventoryItemResponse(
                item.getId(),
                ProductResponse.from(item.getProduct()),
                item.getQuantity(),
                item.getUnit(),
                item.getPrice(),
                item.getLocationText(),
                item.getExpiryDate(),
                item.getStatus().name(),
                item.getOpenedAt(),
                item.getRemainingQuantity());
    }
}
