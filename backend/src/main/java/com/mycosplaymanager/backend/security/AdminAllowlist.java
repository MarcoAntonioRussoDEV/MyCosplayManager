package com.mycosplaymanager.backend.security;

import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/** Unico controllo di autorizzazione per la dashboard admin: nessuna tabella, solo una
 * lista di email in config. Ricontrollata ad ogni richiesta (non solo al login), cosi'
 * togliere un'email dalla env var invalida anche i JWT admin gia' emessi per quell'email. */
@Component
public class AdminAllowlist {

    private final Set<String> allowedEmails;

    public AdminAllowlist(@Value("${mycosplaymanager.admin.allowed-emails:}") String allowedEmailsCsv) {
        this.allowedEmails = Arrays.stream(allowedEmailsCsv.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .map(String::toLowerCase)
                .collect(Collectors.toUnmodifiableSet());
    }

    public boolean isAllowed(String email) {
        return email != null && allowedEmails.contains(email.toLowerCase());
    }
}
