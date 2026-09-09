package com.mycosplaymanager.backend.service;

import java.security.SecureRandom;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.entity.Team;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.TeamRepository;
import com.mycosplaymanager.backend.repository.UserRepository;

@Service
public class TeamService {

    private static final String INVITE_CODE_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int INVITE_CODE_LENGTH = 8;
    private static final SecureRandom RANDOM = new SecureRandom();

    private final TeamRepository teamRepository;
    private final UserRepository userRepository;

    public TeamService(TeamRepository teamRepository, UserRepository userRepository) {
        this.teamRepository = teamRepository;
        this.userRepository = userRepository;
    }

    /** Ogni nuovo utente riceve un laboratorio personale, unibile poi ad altri via invite code. */
    public Team createPersonalTeam(String ownerName) {
        Team team = new Team();
        team.setName("Laboratorio di " + ownerName);
        team.setInviteCode(generateUniqueInviteCode());
        return teamRepository.save(team);
    }

    /** L'utente lascia il proprio team (personale o condiviso) e si unisce a quello del codice invito. */
    @Transactional
    public Team join(User user, String inviteCode) {
        Team team = teamRepository.findByInviteCode(inviteCode.trim().toUpperCase())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Codice invito non valido"));
        user.setTeam(team);
        userRepository.save(user);
        return team;
    }

    private String generateUniqueInviteCode() {
        String code;
        do {
            code = generateInviteCode();
        } while (teamRepository.existsByInviteCode(code));
        return code;
    }

    private String generateInviteCode() {
        StringBuilder sb = new StringBuilder(INVITE_CODE_LENGTH);
        for (int i = 0; i < INVITE_CODE_LENGTH; i++) {
            sb.append(INVITE_CODE_CHARS.charAt(RANDOM.nextInt(INVITE_CODE_CHARS.length())));
        }
        return sb.toString();
    }
}
