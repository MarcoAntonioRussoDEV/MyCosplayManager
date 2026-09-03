package com.cosplayinventory.backend.config;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@Configuration
public class FirebaseConfig {

    private static final Logger log = LoggerFactory.getLogger(FirebaseConfig.class);

    /** Se il file di credenziali non e' configurato/non esiste, le push restano solo loggate
     * (dev locale senza un progetto Firebase reale): FirebaseApp non viene inizializzata. */
    @Bean
    public boolean firebaseEnabled(
            @Value("${cosplayinventory.notification.firebase-credentials-path:}") String credentialsPath) {
        if (credentialsPath == null || credentialsPath.isBlank() || !Files.exists(Path.of(credentialsPath))) {
            log.warn("Firebase non configurato (cosplayinventory.notification.firebase-credentials-path assente "
                    + "o file non trovato): le notifiche push verranno solo loggate");
            return false;
        }
        try (FileInputStream in = new FileInputStream(credentialsPath)) {
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(in))
                    .build();
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(options);
            }
            log.info("Firebase Cloud Messaging inizializzato ({})", credentialsPath);
            return true;
        } catch (IOException e) {
            log.error("Credenziali Firebase presenti ma non leggibili: le push resteranno solo loggate", e);
            return false;
        }
    }
}
