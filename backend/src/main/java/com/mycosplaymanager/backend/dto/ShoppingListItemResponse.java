package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.ShoppingListItem;

public record ShoppingListItemResponse(
        UUID id,
        ProductResponse product,
        String customName,
        BigDecimal quantity,
        String unit,
        boolean purchased) {

    public static ShoppingListItemResponse from(ShoppingListItem item) {
        return new ShoppingListItemResponse(
                item.getId(),
                item.getProduct() != null ? ProductResponse.from(item.getProduct()) : null,
                item.getCustomName(),
                item.getQuantity(),
                item.getUnit(),
                item.isPurchased());
    }
}
