package com.mycosplaymanager.backend.dto;

import java.time.Instant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CreateProjectNoteRequest(
        @NotBlank String text, @NotNull Instant taskAt, @NotNull Instant notifyAt) {
}
