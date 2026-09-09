package com.mycosplaymanager.backend.security;

import org.springframework.stereotype.Component;

import com.mycosplaymanager.backend.repository.AdminEmailRepository;

/** Unico controllo di autorizzazione per la dashboard admin: whitelist in tabella
 * `admin_emails` (gestibile dalla dashboard stessa, vedi AdminEmailController), non
 * piu' in config. Ricontrollata ad ogni richiesta (non solo al login), cosi' rimuovere
 * un'email invalida subito anche i JWT admin gia' emessi per quell'email. */
@Component
public class AdminAllowlist {

    private final AdminEmailRepository adminEmailRepository;

    public AdminAllowlist(AdminEmailRepository adminEmailRepository) {
        this.adminEmailRepository = adminEmailRepository;
    }

    public boolean isAllowed(String email) {
        return email != null && adminEmailRepository.existsByEmailIgnoreCase(email);
    }
}
