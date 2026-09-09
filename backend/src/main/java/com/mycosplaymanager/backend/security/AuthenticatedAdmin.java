package com.mycosplaymanager.backend.security;

/** Principal della dashboard admin: nessun id, la sola identita' che conta e' l'email
 * (verificata contro AdminAllowlist ad ogni richiesta). */
public record AuthenticatedAdmin(String email) {
}
