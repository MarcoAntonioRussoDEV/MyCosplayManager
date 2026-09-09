package com.mycosplaymanager.backend.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.UpdateUserSettingsRequest;
import com.mycosplaymanager.backend.dto.UserResponse;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.UserRepository;
import com.mycosplaymanager.backend.security.AuthenticatedUser;
import com.mycosplaymanager.backend.service.CurrentUserService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final CurrentUserService currentUserService;
    private final UserRepository userRepository;

    public UserController(CurrentUserService currentUserService, UserRepository userRepository) {
        this.currentUserService = currentUserService;
        this.userRepository = userRepository;
    }

    @GetMapping("/me")
    public UserResponse me(@AuthenticationPrincipal AuthenticatedUser principal) {
        return UserResponse.from(currentUserService.require(principal));
    }

    @PatchMapping("/me")
    @Transactional
    public UserResponse updateSettings(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody UpdateUserSettingsRequest request) {
        User user = currentUserService.require(principal);
        user.setNotificationDaysBefore(request.notificationDaysBefore());
        return UserResponse.from(userRepository.save(user));
    }
}
