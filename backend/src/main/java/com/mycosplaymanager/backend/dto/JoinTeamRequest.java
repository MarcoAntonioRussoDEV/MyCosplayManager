package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.NotBlank;

public record JoinTeamRequest(@NotBlank String inviteCode) {
}
