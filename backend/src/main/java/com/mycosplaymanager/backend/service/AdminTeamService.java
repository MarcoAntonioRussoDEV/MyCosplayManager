package com.mycosplaymanager.backend.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycosplaymanager.backend.dto.AdminTeamResponse;
import com.mycosplaymanager.backend.entity.Team;
import com.mycosplaymanager.backend.repository.TeamRepository;
import com.mycosplaymanager.backend.repository.UserRepository;

@Transactional(readOnly = true)
@Service
public class AdminTeamService {

    private final TeamRepository teamRepository;
    private final UserRepository userRepository;

    public AdminTeamService(TeamRepository teamRepository, UserRepository userRepository) {
        this.teamRepository = teamRepository;
        this.userRepository = userRepository;
    }

    public List<AdminTeamResponse> listAll() {
        List<Team> teams = teamRepository.findAll();
        // Dataset piccolo (dev/piccola scala): un conteggio in memoria evita N query,
        // una per team, per calcolare memberCount.
        Map<java.util.UUID, Long> countsByTeam = userRepository.findAll().stream()
                .collect(Collectors.groupingBy(u -> u.getTeam().getId(), Collectors.counting()));
        return teams.stream()
                .map(team -> AdminTeamResponse.from(team, countsByTeam.getOrDefault(team.getId(), 0L).intValue()))
                .toList();
    }
}
