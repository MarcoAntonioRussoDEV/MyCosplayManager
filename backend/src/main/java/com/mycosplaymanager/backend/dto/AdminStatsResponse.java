package com.mycosplaymanager.backend.dto;

public record AdminStatsResponse(long userCount, long teamCount, long productCount, long inventoryItemCount) {
}
