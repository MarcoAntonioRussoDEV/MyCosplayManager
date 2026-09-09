package com.mycosplaymanager.backend.dto;

import jakarta.validation.constraints.NotBlank;

/** email facoltativa: se assente la notifica va a tutti i dispositivi registrati (broadcast),
 * utile per i test end-to-end della pipeline push senza dover aspettare uno scheduler. */
public record SendNotificationRequest(@NotBlank String title, @NotBlank String body, String email) {
}
