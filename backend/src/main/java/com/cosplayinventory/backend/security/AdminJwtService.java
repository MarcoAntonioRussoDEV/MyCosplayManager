package com.cosplayinventory.backend.security;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

/** Token separati da quelli utente (stesso secret, claim "typ" distinto): un JWT utente
 * non puo' essere riusato sugli endpoint /api/admin/** e viceversa. Subject = email
 * (nessuna tabella admin: l'autorizzazione vera e' AdminAllowlist, ricontrollata ad
 * ogni richiesta dal filtro, non solo al login). */
@Component
public class AdminJwtService {

    private static final String CLAIM_TYPE = "typ";
    private static final String TYPE_ADMIN = "admin";

    private final SecretKey signingKey;
    private final long expirationMinutes;

    public AdminJwtService(
            @Value("${cosplayinventory.jwt.secret}") String secret,
            @Value("${cosplayinventory.jwt.admin-expiration-minutes:480}") long expirationMinutes) {
        this.signingKey = Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));
        this.expirationMinutes = expirationMinutes;
    }

    public String generateToken(String email) {
        Instant now = Instant.now();
        return Jwts.builder()
                .subject(email)
                .claim(CLAIM_TYPE, TYPE_ADMIN)
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plus(expirationMinutes, ChronoUnit.MINUTES)))
                .signWith(signingKey)
                .compact();
    }

    public AuthenticatedAdmin parseToken(String token) {
        Claims claims = Jwts.parser().verifyWith(signingKey).build().parseSignedClaims(token).getPayload();
        if (!TYPE_ADMIN.equals(claims.get(CLAIM_TYPE, String.class))) {
            throw new JwtException("Non e' un token admin");
        }
        return new AuthenticatedAdmin(claims.getSubject());
    }
}
