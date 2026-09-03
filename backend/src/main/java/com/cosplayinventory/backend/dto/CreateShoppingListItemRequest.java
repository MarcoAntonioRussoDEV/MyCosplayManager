package com.cosplayinventory.backend.dto;

import java.math.BigDecimal;
import java.util.UUID;

public record CreateShoppingListItemRequest(
        UUID productId,
        String customName,
        BigDecimal quantity,
        String unit) {
}
