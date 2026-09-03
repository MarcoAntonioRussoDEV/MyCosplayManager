package com.cosplayinventory.backend.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record UpdateUserSettingsRequest(@NotNull @Min(0) @Max(30) Integer notificationDaysBefore) {
}
