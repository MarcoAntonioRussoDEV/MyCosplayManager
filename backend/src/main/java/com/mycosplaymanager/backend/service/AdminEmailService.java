package com.mycosplaymanager.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.entity.AdminEmail;
import com.mycosplaymanager.backend.repository.AdminEmailRepository;

@Transactional(readOnly = true)
@Service
public class AdminEmailService {

    private final AdminEmailRepository adminEmailRepository;

    public AdminEmailService(AdminEmailRepository adminEmailRepository) {
        this.adminEmailRepository = adminEmailRepository;
    }

    public List<AdminEmail> listAll() {
        return adminEmailRepository.findAllByOrderByCreatedAtAsc();
    }

    @Transactional
    public AdminEmail add(String email) {
        String normalized = email.trim().toLowerCase();
        if (adminEmailRepository.existsByEmailIgnoreCase(normalized)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email gia' autorizzata");
        }
        AdminEmail adminEmail = new AdminEmail();
        adminEmail.setEmail(normalized);
        return adminEmailRepository.save(adminEmail);
    }

    /** Non permette di rimuovere l'ultimo admin rimasto: si perderebbe l'accesso alla
     * dashboard senza modo di ripristinarlo da li' (servirebbe intervenire sul DB). */
    @Transactional
    public void remove(UUID id) {
        if (!adminEmailRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Email non trovata");
        }
        if (adminEmailRepository.count() <= 1) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Non puoi rimuovere l'ultimo admin");
        }
        adminEmailRepository.deleteById(id);
    }
}
