package com.mycosplaymanager.backend.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.AdminTeamResponse;
import com.mycosplaymanager.backend.service.AdminTeamService;

@RestController
@RequestMapping("/api/admin/teams")
public class AdminTeamController {

    private final AdminTeamService adminTeamService;

    public AdminTeamController(AdminTeamService adminTeamService) {
        this.adminTeamService = adminTeamService;
    }

    @GetMapping
    public List<AdminTeamResponse> list() {
        return adminTeamService.listAll();
    }
}
