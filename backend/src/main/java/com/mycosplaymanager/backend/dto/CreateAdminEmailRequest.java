package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

public record CreateAdminEmailRequest(@NotBlank @Email String email) {
}
