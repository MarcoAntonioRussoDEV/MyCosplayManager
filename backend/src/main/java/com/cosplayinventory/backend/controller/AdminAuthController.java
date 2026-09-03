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

import com.cosplayinventory.backend.dto.AdminAuthResponse;
import com.cosplayinventory.backend.dto.AdminGoogleLoginRequest;
import com.cosplayinventory.backend.security.AdminAllowlist;
import com.cosplayinventory.backend.security.AdminJwtService;
import com.cosplayinventory.backend.security.GoogleTokenVerifierService;
import com.cosplayinventory.backend.security.GoogleTokenVerifierService.GoogleUserInfo;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/admin/auth")
public class AdminAuthController {

    private final GoogleTokenVerifierService googleTokenVerifierService;
    private final AdminAllowlist adminAllowlist;
    private final AdminJwtService adminJwtService;

    public AdminAuthController(
            GoogleTokenVerifierService googleTokenVerifierService,
            AdminAllowlist adminAllowlist,
            AdminJwtService adminJwtService) {
        this.googleTokenVerifierService = googleTokenVerifierService;
        this.adminAllowlist = adminAllowlist;
        this.adminJwtService = adminJwtService;
    }

    /** Stesso client OAuth Web e stessa verifica ID token dell'app mobile
     * (GoogleTokenVerifierService): qui in piu' l'email deve essere in whitelist. */
    @PostMapping("/google")
    public AdminAuthResponse google(@Valid @RequestBody AdminGoogleLoginRequest request) {
        GoogleUserInfo googleUser = googleTokenVerifierService.verify(request.idToken());
        if (!adminAllowlist.isAllowed(googleUser.email())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Account non autorizzato per la dashboard admin");
        }
        String token = adminJwtService.generateToken(googleUser.email());
        return new AdminAuthResponse(googleUser.email(), token);
    }

    @ExceptionHandler(GoogleTokenVerifierService.GoogleTokenInvalidException.class)
    public ResponseEntity<Map<String, String>> handleInvalidGoogleToken(GoogleTokenVerifierService.GoogleTokenInvalidException e) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", e.getMessage()));
    }
}
