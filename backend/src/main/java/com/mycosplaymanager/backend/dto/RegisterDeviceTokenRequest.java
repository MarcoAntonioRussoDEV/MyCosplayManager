package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.NotBlank;

public record RegisterDeviceTokenRequest(@NotBlank String fcmToken, String platform) {
}
