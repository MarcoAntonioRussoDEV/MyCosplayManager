package com.mycosplaymanager.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.UserRepository;

@Transactional(readOnly = true)
@Service
public class AdminUserService {

    private final UserRepository userRepository;

    public AdminUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public List<User> listAll() {
        return userRepository.findAllWithTeam();
    }

    @Transactional
    public User setBanned(UUID id, boolean banned) {
        User user = userRepository.findWithTeamById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Utente non trovato"));
        user.setBanned(banned);
        return userRepository.save(user);
    }
}
