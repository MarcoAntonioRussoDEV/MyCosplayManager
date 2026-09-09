package com.mycosplaymanager.backend.dto;

import java.time.Instant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record UpdateProjectNoteRequest(@NotBlank String text, @NotNull Instant notifyAt) {
}
