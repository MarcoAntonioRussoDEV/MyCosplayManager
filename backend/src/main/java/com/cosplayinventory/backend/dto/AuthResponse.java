package com.cosplayinventory.backend.dto;

import java.util.UUID;

public record AuthResponse(UUID userId, String email, String name, UUID teamId, String token) {
}
