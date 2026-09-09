package com.mycosplaymanager.backend.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.JoinTeamRequest;
import com.mycosplaymanager.backend.dto.TeamResponse;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.security.AuthenticatedUser;
import com.mycosplaymanager.backend.service.CurrentUserService;
import com.mycosplaymanager.backend.service.TeamService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/teams")
public class TeamController {

    private final TeamService teamService;
    private final CurrentUserService currentUserService;

    public TeamController(TeamService teamService, CurrentUserService currentUserService) {
        this.teamService = teamService;
        this.currentUserService = currentUserService;
    }

    // Transazionale: user.getTeam() e' un proxy lazy (open-in-view: false), va risolto
    // prima che la sessione Hibernate si chiuda, altrimenti TeamResponse.from() la' sotto
    // lancia LazyInitializationException.
    @Transactional(readOnly = true)
    @GetMapping("/me")
    public TeamResponse me(@AuthenticationPrincipal AuthenticatedUser principal) {
        User user = currentUserService.require(principal);
        return TeamResponse.from(user.getTeam());
    }

    /** L'utente lascia il team attuale e si unisce a quello del codice invito. */
    @PostMapping("/join")
    public TeamResponse join(
            @AuthenticationPrincipal AuthenticatedUser principal, @Valid @RequestBody JoinTeamRequest request) {
        User user = currentUserService.require(principal);
        return TeamResponse.from(teamService.join(user, request.inviteCode()));
    }
}
