package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.NotNull;

import com.mycosplaymanager.backend.entity.InventoryItemStatus;

public record ChangeInventoryItemStatusRequest(@NotNull InventoryItemStatus status) {
}
