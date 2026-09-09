package com.mycosplaymanager.backend.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.AdminEmailResponse;
import com.mycosplaymanager.backend.dto.CreateAdminEmailRequest;
import com.mycosplaymanager.backend.service.AdminEmailService;

import jakarta.validation.Valid;

/** Gestione della whitelist di accesso alla dashboard admin (vedi AdminAllowlist). */
@RestController
@RequestMapping("/api/admin/admins")
public class AdminEmailController {

    private final AdminEmailService adminEmailService;

    public AdminEmailController(AdminEmailService adminEmailService) {
        this.adminEmailService = adminEmailService;
    }

    @GetMapping
    public List<AdminEmailResponse> list() {
        return adminEmailService.listAll().stream().map(AdminEmailResponse::from).toList();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public AdminEmailResponse add(@Valid @RequestBody CreateAdminEmailRequest request) {
        return AdminEmailResponse.from(adminEmailService.add(request.email()));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void remove(@PathVariable UUID id) {
        adminEmailService.remove(id);
    }
}
