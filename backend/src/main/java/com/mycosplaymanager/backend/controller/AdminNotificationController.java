package com.mycosplaymanager.backend.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.SendNotificationRequest;
import com.mycosplaymanager.backend.dto.SendNotificationResponse;
import com.mycosplaymanager.backend.service.AdminNotificationService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/admin/notifications")
public class AdminNotificationController {

    private final AdminNotificationService adminNotificationService;

    public AdminNotificationController(AdminNotificationService adminNotificationService) {
        this.adminNotificationService = adminNotificationService;
    }

    /** Notifica push "a comando", per test manuali della pipeline senza aspettare uno
     * scheduler: broadcast a tutti i dispositivi se `email` e' assente, altrimenti solo
     * ai dispositivi di quell'utente. */
    @PostMapping("/send")
    public SendNotificationResponse send(@Valid @RequestBody SendNotificationRequest request) {
        return new SendNotificationResponse(adminNotificationService.send(request));
    }
}
