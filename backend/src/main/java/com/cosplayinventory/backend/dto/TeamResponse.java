package com.cosplayinventory.backend.dto;

import java.util.UUID;

import com.cosplayinventory.backend.entity.Team;

public record TeamResponse(UUID id, String name, String inviteCode) {

    public static TeamResponse from(Team team) {
        return new TeamResponse(team.getId(), team.getName(), team.getInviteCode());
    }
}
