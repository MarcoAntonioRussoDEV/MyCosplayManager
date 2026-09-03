package com.cosplayinventory.backend.dto;

import java.util.UUID;

import com.cosplayinventory.backend.entity.User;

public record UserResponse(UUID id, String email, String name, UUID teamId, int notificationDaysBefore) {

    public static UserResponse from(User user) {
        return new UserResponse(
                user.getId(), user.getEmail(), user.getName(), user.getTeam().getId(), user.getNotificationDaysBefore());
    }
}
