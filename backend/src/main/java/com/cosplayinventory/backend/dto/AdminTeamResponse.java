package com.cosplayinventory.backend.dto;

import java.time.Instant;
import java.util.UUID;

import com.cosplayinventory.backend.entity.Team;

public record AdminTeamResponse(UUID id, String name, String inviteCode, int memberCount, Instant createdAt) {

    public static AdminTeamResponse from(Team team, int memberCount) {
        return new AdminTeamResponse(team.getId(), team.getName(), team.getInviteCode(), memberCount, team.getCreatedAt());
    }
}
