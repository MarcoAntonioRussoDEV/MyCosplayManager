package com.mycosplaymanager.backend.service;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.SendNotificationRequest;
import com.mycosplaymanager.backend.entity.DeviceToken;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.DeviceTokenRepository;
import com.mycosplaymanager.backend.repository.UserRepository;

@Service
public class AdminNotificationService {

    private final UserRepository userRepository;
    private final DeviceTokenRepository deviceTokenRepository;
    private final PushNotificationService pushNotificationService;

    public AdminNotificationService(
            UserRepository userRepository,
            DeviceTokenRepository deviceTokenRepository,
            PushNotificationService pushNotificationService) {
        this.userRepository = userRepository;
        this.deviceTokenRepository = deviceTokenRepository;
        this.pushNotificationService = pushNotificationService;
    }

    /** Invia a un utente specifico (email valorizzata) o in broadcast a tutti i dispositivi
     * registrati (email assente/vuota). Torna il numero di dispositivi raggiunti. */
    public int send(SendNotificationRequest request) {
        List<DeviceToken> tokens;
        if (request.email() != null && !request.email().isBlank()) {
            User user = userRepository.findByEmail(request.email().trim())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Utente non trovato"));
            tokens = deviceTokenRepository.findByUserId(user.getId());
        } else {
            tokens = deviceTokenRepository.findAll();
        }

        for (DeviceToken token : tokens) {
            pushNotificationService.send(token.getFcmToken(), request.title(), request.body());
        }
        return tokens.size();
    }
}
