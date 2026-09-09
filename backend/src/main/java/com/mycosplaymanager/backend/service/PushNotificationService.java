package com.mycosplaymanager.backend.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

@Service
public class PushNotificationService {

    private static final Logger log = LoggerFactory.getLogger(PushNotificationService.class);

    private final boolean firebaseEnabled;

    public PushNotificationService(boolean firebaseEnabled) {
        this.firebaseEnabled = firebaseEnabled;
    }

    public void send(String fcmToken, String title, String body) {
        if (!firebaseEnabled) {
            log.info("[push simulata, Firebase non configurato] token={} title=\"{}\" body=\"{}\"", fcmToken, title, body);
            return;
        }
        Message message = Message.builder()
                .setToken(fcmToken)
                .setNotification(Notification.builder().setTitle(title).setBody(body).build())
                .build();
        try {
            FirebaseMessaging.getInstance().send(message);
        } catch (FirebaseMessagingException e) {
            log.warn("Invio push fallito per token {}: {}", fcmToken, e.getMessage());
        }
    }
}
