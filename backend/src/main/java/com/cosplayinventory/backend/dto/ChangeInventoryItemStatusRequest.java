package com.cosplayinventory.backend.dto;

import jakarta.validation.constraints.NotNull;

import com.cosplayinventory.backend.entity.InventoryItemStatus;

public record ChangeInventoryItemStatusRequest(@NotNull InventoryItemStatus status) {
}
