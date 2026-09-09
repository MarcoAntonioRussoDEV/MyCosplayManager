package com.mycosplaymanager.backend.security;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class AdminJwtAuthenticationFilter extends OncePerRequestFilter {

    private static final Logger log = LoggerFactory.getLogger(AdminJwtAuthenticationFilter.class);
    private static final String BEARER_PREFIX = "Bearer ";

    private final AdminJwtService adminJwtService;
    private final AdminAllowlist adminAllowlist;

    public AdminJwtAuthenticationFilter(AdminJwtService adminJwtService, AdminAllowlist adminAllowlist) {
        this.adminJwtService = adminJwtService;
        this.adminAllowlist = adminAllowlist;
    }

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain) throws ServletException, IOException {

        String header = request.getHeader("Authorization");
        if (header != null && header.startsWith(BEARER_PREFIX)) {
            try {
                AuthenticatedAdmin admin = adminJwtService.parseToken(header.substring(BEARER_PREFIX.length()));
                // Ricontrollata ad ogni richiesta, non solo al login: togliere un'email
                // dalla whitelist deve invalidare subito anche i token gia' emessi.
                if (adminAllowlist.isAllowed(admin.email())) {
                    var authentication = new UsernamePasswordAuthenticationToken(admin, null, List.of());
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                } else {
                    log.debug("Token JWT admin valido ma {} non e' (piu') in whitelist", admin.email());
                    SecurityContextHolder.clearContext();
                }
            } catch (JwtException | IllegalArgumentException e) {
                log.debug("Token JWT admin non valido: {}", e.getMessage());
                SecurityContextHolder.clearContext();
            }
        }

        filterChain.doFilter(request, response);
    }
}
