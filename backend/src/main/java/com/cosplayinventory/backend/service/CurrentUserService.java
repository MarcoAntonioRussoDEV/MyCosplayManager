package com.cosplayinventory.backend.service;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.cosplayinventory.backend.entity.User;
import com.cosplayinventory.backend.repository.UserRepository;
import com.cosplayinventory.backend.security.AuthenticatedUser;

/** Risolve lo User/Team di dominio a partire dal principal JWT: usato da ogni
 * controller che deve scopare i dati sul team dell'utente autenticato. */
@Service
public class CurrentUserService {

    private final UserRepository userRepository;

    public CurrentUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User require(AuthenticatedUser principal) {
        return userRepository.findById(principal.id())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Utente non trovato"));
    }
}
