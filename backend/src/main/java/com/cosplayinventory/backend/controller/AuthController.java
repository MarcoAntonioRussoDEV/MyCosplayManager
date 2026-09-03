package com.cosplayinventory.backend.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.cosplayinventory.backend.dto.AuthResponse;
import com.cosplayinventory.backend.dto.GoogleAuthRequest;
import com.cosplayinventory.backend.entity.User;
import com.cosplayinventory.backend.repository.UserRepository;
import com.cosplayinventory.backend.security.GoogleTokenVerifierService;
import com.cosplayinventory.backend.security.GoogleTokenVerifierService.GoogleUserInfo;
import com.cosplayinventory.backend.security.JwtService;
import com.cosplayinventory.backend.service.TeamService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserRepository userRepository;
    private final JwtService jwtService;
    private final GoogleTokenVerifierService googleTokenVerifierService;
    private final TeamService teamService;

    public AuthController(
            UserRepository userRepository,
            JwtService jwtService,
            GoogleTokenVerifierService googleTokenVerifierService,
            TeamService teamService) {
        this.userRepository = userRepository;
        this.jwtService = jwtService;
        this.googleTokenVerifierService = googleTokenVerifierService;
        this.teamService = teamService;
    }

    /** Unico modo di autenticarsi: login/registrazione sono lo stesso endpoint, come da backlog. */
    @PostMapping("/google")
    public AuthResponse google(@Valid @RequestBody GoogleAuthRequest request) {
        GoogleUserInfo googleUser = googleTokenVerifierService.verify(request.idToken());

        User user = userRepository.findByGoogleId(googleUser.googleId())
                .or(() -> userRepository.findByEmail(googleUser.email()))
                .orElseGet(() -> {
                    User newUser = new User();
                    newUser.setEmail(googleUser.email());
                    newUser.setName(displayNameOrEmailPrefix(googleUser.name(), googleUser.email()));
                    newUser.setGoogleId(googleUser.googleId());
                    newUser.setTeam(teamService.createPersonalTeam(newUser.getName()));
                    return newUser;
                });

        if (user.isBanned()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Account sospeso. Contatta l'assistenza.");
        }

        // Riallinea googleId/nome anche se l'utente esisteva gia' (es. trovato per email).
        user.setGoogleId(googleUser.googleId());
        if (googleUser.name() != null && !googleUser.name().isBlank()) {
            user.setName(googleUser.name().trim());
        }
        user = userRepository.save(user);

        String token = jwtService.generateToken(user.getId(), user.getEmail());
        return new AuthResponse(user.getId(), user.getEmail(), user.getName(), user.getTeam().getId(), token);
    }

    private static String displayNameOrEmailPrefix(String name, String email) {
        if (name != null && !name.isBlank()) return name.trim();
        int at = email.indexOf('@');
        return at > 0 ? email.substring(0, at) : email;
    }

    @ExceptionHandler(GoogleTokenVerifierService.GoogleTokenInvalidException.class)
    public ResponseEntity<Map<String, String>> handleInvalidGoogleToken(GoogleTokenVerifierService.GoogleTokenInvalidException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", e.getMessage()));
    }
}
