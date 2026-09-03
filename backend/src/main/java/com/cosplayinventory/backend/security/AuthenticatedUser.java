package com.cosplayinventory.backend.security;

import java.util.UUID;

/** Principal applicativo estratto dal JWT, iniettabile via @AuthenticationPrincipal. */
public record AuthenticatedUser(UUID id, String email) {
}
