package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.NotNull;

public record SetProjectNoteDoneRequest(@NotNull Boolean done) {
}
