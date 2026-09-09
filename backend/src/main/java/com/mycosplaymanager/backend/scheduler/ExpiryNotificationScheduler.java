package com.mycosplaymanager.backend.scheduler;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.mycosplaymanager.backend.entity.DeviceToken;
import com.mycosplaymanager.backend.entity.InventoryItem;
import com.mycosplaymanager.backend.entity.InventoryItemStatus;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.DeviceTokenRepository;
import com.mycosplaymanager.backend.repository.InventoryItemRepository;
import com.mycosplaymanager.backend.repository.UserRepository;
import com.mycosplaymanager.backend.service.ExpiryCalculationService;
import com.mycosplaymanager.backend.service.PushNotificationService;

@Component
public class ExpiryNotificationScheduler {

    private static final Logger log = LoggerFactory.getLogger(ExpiryNotificationScheduler.class);
    private static final List<InventoryItemStatus> NOT_ACTIVE =
            List.of(InventoryItemStatus.CONSUMED, InventoryItemStatus.DISCARDED);

    private final InventoryItemRepository inventoryItemRepository;
    private final UserRepository userRepository;
    private final DeviceTokenRepository deviceTokenRepository;
    private final ExpiryCalculationService expiryCalculationService;
    private final PushNotificationService pushNotificationService;

    public ExpiryNotificationScheduler(
            InventoryItemRepository inventoryItemRepository,
            UserRepository userRepository,
            DeviceTokenRepository deviceTokenRepository,
            ExpiryCalculationService expiryCalculationService,
            PushNotificationService pushNotificationService) {
        this.inventoryItemRepository = inventoryItemRepository;
        this.userRepository = userRepository;
        this.deviceTokenRepository = deviceTokenRepository;
        this.expiryCalculationService = expiryCalculationService;
        this.pushNotificationService = pushNotificationService;
    }

    @Scheduled(cron = "${mycosplaymanager.notification.scan-cron}")
    @Transactional
    public void run() {
        LocalDate today = LocalDate.now();
        List<InventoryItem> activeItems = inventoryItemRepository.findByStatusNotInAndExpiryDateIsNotNull(NOT_ACTIVE);
        int notifiedItems = 0;

        for (InventoryItem item : activeItems) {
            if (today.equals(item.getLastNotifiedDate())) {
                continue;
            }
            LocalDate effectiveExpiry = expiryCalculationService.effectiveExpiryDate(item);
            if (effectiveExpiry == null) {
                continue;
            }
            long daysUntil = ChronoUnit.DAYS.between(today, effectiveExpiry);

            boolean notifiedSomeone = false;
            for (User member : userRepository.findByTeamId(item.getTeam().getId())) {
                if (daysUntil > member.getNotificationDaysBefore()) {
                    continue;
                }
                for (DeviceToken deviceToken : deviceTokenRepository.findByUserId(member.getId())) {
                    pushNotificationService.send(
                            deviceToken.getFcmToken(),
                            "Scadenza in arrivo",
                            item.getProduct().getName() + " scade il " + effectiveExpiry);
                    notifiedSomeone = true;
                }
            }

            // Dedupe giornaliero per item (non per membro): basta una notifica al giorno
            // per articolo, anche se il team ha piu' persone con soglie diverse.
            if (notifiedSomeone) {
                item.setLastNotifiedDate(today);
                inventoryItemRepository.save(item);
                notifiedItems++;
            }
        }

        if (notifiedItems > 0) {
            log.info("Scheduler scadenze: inviate notifiche per {} articoli", notifiedItems);
        }
    }
}
