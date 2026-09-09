package com.mycosplaymanager.backend.dto;

import java.time.Instant;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.User;

public record AdminUserResponse(
        UUID id, String email, String name, UUID teamId, String teamName,
        int notificationDaysBefore, boolean banned, Instant createdAt) {

    public static AdminUserResponse from(User user) {
        return new AdminUserResponse(
                user.getId(), user.getEmail(), user.getName(),
                user.getTeam().getId(), user.getTeam().getName(),
                user.getNotificationDaysBefore(), user.isBanned(), user.getCreatedAt());
    }
}
