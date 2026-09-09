package com.mycosplaymanager.backend.controller;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.RegisterDeviceTokenRequest;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.security.AuthenticatedUser;
import com.mycosplaymanager.backend.service.CurrentUserService;
import com.mycosplaymanager.backend.service.DeviceTokenService;

import jakarta.validation.Valid;

/** Registrazione token FCM: l'app la chiama dopo il login e ad ogni refresh del token. */
@RestController
@RequestMapping("/api/device-tokens")
public class DeviceTokenController {

    private final DeviceTokenService deviceTokenService;
    private final CurrentUserService currentUserService;

    public DeviceTokenController(DeviceTokenService deviceTokenService, CurrentUserService currentUserService) {
        this.deviceTokenService = deviceTokenService;
        this.currentUserService = currentUserService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void register(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody RegisterDeviceTokenRequest request) {
        User user = currentUserService.require(principal);
        deviceTokenService.register(user, request.fcmToken(), request.platform());
    }

    @DeleteMapping("/{fcmToken}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void unregister(@PathVariable String fcmToken) {
        deviceTokenService.unregister(fcmToken);
    }
}
