package com.cosplayinventory.backend.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cosplayinventory.backend.entity.DeviceToken;
import com.cosplayinventory.backend.entity.User;
import com.cosplayinventory.backend.repository.DeviceTokenRepository;

@Service
public class DeviceTokenService {

    private final DeviceTokenRepository deviceTokenRepository;

    public DeviceTokenService(DeviceTokenRepository deviceTokenRepository) {
        this.deviceTokenRepository = deviceTokenRepository;
    }

    @Transactional
    public void register(User user, String fcmToken, String platform) {
        // Lo stesso token puo' arrivare di nuovo (refresh app senza reinstall): aggiorna
        // l'utente proprietario invece di violare lo UNIQUE su fcm_token.
        DeviceToken deviceToken = deviceTokenRepository.findByFcmToken(fcmToken).orElseGet(DeviceToken::new);
        deviceToken.setUser(user);
        deviceToken.setFcmToken(fcmToken);
        deviceToken.setPlatform(platform != null && !platform.isBlank() ? platform : "ANDROID");
        deviceTokenRepository.save(deviceToken);
    }

    @Transactional
    public void unregister(String fcmToken) {
        deviceTokenRepository.findByFcmToken(fcmToken).ifPresent(deviceTokenRepository::delete);
    }
}
