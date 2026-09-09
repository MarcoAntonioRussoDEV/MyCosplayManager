package com.mycosplaymanager.backend.security;

import java.time.Instant;
import java.util.List;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import jakarta.servlet.http.HttpServletResponse;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final AdminJwtAuthenticationFilter adminJwtAuthenticationFilter;

    public SecurityConfig(
            JwtAuthenticationFilter jwtAuthenticationFilter,
            AdminJwtAuthenticationFilter adminJwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.adminJwtAuthenticationFilter = adminJwtAuthenticationFilter;
    }

    // I due filtri sono @Component: senza questo, Spring Boot li auto-registra ANCHE come
    // filtri servlet globali (FilterRegistrationBean automatico per ogni Filter-bean trovato),
    // in piu' al addFilterBefore(...) qui sotto che li inserisce nella security chain vera e
    // propria. La copia globale gira fuori dal ciclo di vita di SecurityContextHolderFilter e
    // il SecurityContext che imposta viene perso prima che il controller lo legga
    // (@AuthenticationPrincipal arriva null, NPE a valle). Disabilitarla lascia solo la copia
    // dentro la chain, quella vista da addFilterBefore.
    @Bean
    public FilterRegistrationBean<JwtAuthenticationFilter> jwtAuthenticationFilterRegistration(
            JwtAuthenticationFilter filter) {
        FilterRegistrationBean<JwtAuthenticationFilter> registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }

    @Bean
    public FilterRegistrationBean<AdminJwtAuthenticationFilter> adminJwtAuthenticationFilterRegistration(
            AdminJwtAuthenticationFilter filter) {
        FilterRegistrationBean<AdminJwtAuthenticationFilter> registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // Permissivo per sviluppo: client Flutter/React su origin diverse dal backend.
        // Restringere quando esistera' un dominio di produzione definito.
        configuration.setAllowedOriginPatterns(List.of("*"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    private void unauthorizedJson(HttpSecurity http) throws Exception {
        http.exceptionHandling(exceptions -> exceptions.authenticationEntryPoint((request, response, authException) -> {
            // Senza un entry point esplicito, richieste senza (o con) autenticazione non valida
            // possono ricevere 403 invece del 401 corretto: il client deve poter distinguere
            // "token assente/invalido/utente sparito" da "azione non permessa".
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write(
                    "{\"timestamp\":\"" + Instant.now() + "\",\"status\":401,\"error\":\"Unauthorized\","
                            + "\"path\":\"" + request.getRequestURI() + "\"}");
        }));
    }

    /** Chain separata per /api/admin/**: un token utente app non e' mai valido qui
     * (AdminJwtAuthenticationFilter accetta solo token con claim typ=admin).
     *
     * IMPORTANTE: securityMatcher(String...) usa PathPatternRequestMatcher, che con piu'
     * SecurityFilterChain fa scattare in WebMvcSecurityConfiguration un CompositeFilterChainProxy
     * (serve l'introspezione di HandlerMappingIntrospector) — in quel percorso il
     * SecurityContext impostato da JwtAuthenticationFilter sull'altra chain viene svuotato
     * prima che il controller lo legga (@AuthenticationPrincipal arriva null, NPE a valle).
     * AntPathRequestMatcher esplicito evita quel meccanismo. */
    @Bean
    @Order(1)
    public SecurityFilterChain adminFilterChain(HttpSecurity http) throws Exception {
        http
                .securityMatcher(new AntPathRequestMatcher("/api/admin/**"))
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(csrf -> csrf.disable())
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/admin/auth/**").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(adminJwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        unauthorizedJson(http);
        return http.build();
    }

    @Bean
    @Order(2)
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(csrf -> csrf.disable())
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/uploads/**").permitAll()
                        // Spring inoltra internamente le eccezioni non gestite verso /error (stesso
                        // thread/richiesta, non un nuovo giro di autenticazione): senza questo permitAll
                        // qualunque ResponseStatusException (404/409/...) diventa un 403 generico perche'
                        // il forward verso /error viene bloccato da anyRequest().authenticated().
                        .requestMatchers("/error").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        unauthorizedJson(http);
        return http.build();
    }
}
