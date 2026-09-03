package com.cosplayinventory.backend.dto;

import jakarta.validation.constraints.NotBlank;

public record RegisterDeviceTokenRequest(@NotBlank String fcmToken, String platform) {
}
