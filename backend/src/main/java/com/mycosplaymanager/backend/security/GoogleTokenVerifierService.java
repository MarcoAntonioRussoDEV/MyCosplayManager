package com.mycosplaymanager.backend.security;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;

@Service
public class GoogleTokenVerifierService {

    public record GoogleUserInfo(String googleId, String email, String name) {
    }

    private final GoogleIdTokenVerifier verifier;

    public GoogleTokenVerifierService(@Value("${mycosplaymanager.google.client-ids}") String clientIdsCsv) {
        List<String> audiences = Arrays.stream(clientIdsCsv.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();
        this.verifier = new GoogleIdTokenVerifier.Builder(new NetHttpTransport(), GsonFactory.getDefaultInstance())
                .setAudience(audiences.isEmpty() ? Collections.emptyList() : audiences)
                .build();
    }

    /** Verifica firma, audience e scadenza dell'ID token Google. Lancia se non valido. */
    public GoogleUserInfo verify(String idTokenString) {
        try {
            GoogleIdToken idToken = verifier.verify(idTokenString);
            if (idToken == null) {
                throw new GoogleTokenInvalidException("ID token Google non valido");
            }
            GoogleIdToken.Payload payload = idToken.getPayload();
            Object name = payload.get("name");
            return new GoogleUserInfo(payload.getSubject(), payload.getEmail(), name != null ? name.toString() : null);
        } catch (GeneralSecurityException | IOException | IllegalArgumentException e) {
            // IllegalArgumentException: la libreria la lancia per un token strutturalmente
            // malformato (non un JWT valido), prima ancora di provare a verificarne la firma.
            throw new GoogleTokenInvalidException("Verifica ID token Google fallita", e);
        }
    }

    public static class GoogleTokenInvalidException extends RuntimeException {
        public GoogleTokenInvalidException(String message) {
            super(message);
        }

        public GoogleTokenInvalidException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
