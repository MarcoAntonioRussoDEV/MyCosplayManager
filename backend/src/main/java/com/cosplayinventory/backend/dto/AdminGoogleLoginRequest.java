package com.cosplayinventory.backend.dto;

import jakarta.validation.constraints.NotBlank;

public record AdminGoogleLoginRequest(@NotBlank String idToken) {
}
