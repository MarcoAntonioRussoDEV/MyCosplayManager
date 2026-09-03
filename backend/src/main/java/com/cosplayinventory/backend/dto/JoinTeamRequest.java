package com.cosplayinventory.backend.dto;

import jakarta.validation.constraints.NotBlank;

public record JoinTeamRequest(@NotBlank String inviteCode) {
}
