package com.mycosplaymanager.backend.scheduler;

import java.time.Instant;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.mycosplaymanager.backend.entity.DeviceToken;
import com.mycosplaymanager.backend.entity.ProjectNote;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.DeviceTokenRepository;
import com.mycosplaymanager.backend.repository.ProjectNoteRepository;
import com.mycosplaymanager.backend.repository.UserRepository;
import com.mycosplaymanager.backend.service.PushNotificationService;

/** Notifica one-shot: appena `now >= notifyAt` per una nota non ancora notificata, avvisa
 * tutti i membri del team (non solo chi ha una soglia personale superata, a differenza di
 * ExpiryNotificationScheduler) e marca `notified`, senza piu' ripetere ogni giorno. */
@Component
public class ProjectNoteNotificationScheduler {

    private static final Logger log = LoggerFactory.getLogger(ProjectNoteNotificationScheduler.class);

    private final ProjectNoteRepository projectNoteRepository;
    private final UserRepository userRepository;
    private final DeviceTokenRepository deviceTokenRepository;
    private final PushNotificationService pushNotificationService;

    public ProjectNoteNotificationScheduler(
            ProjectNoteRepository projectNoteRepository,
            UserRepository userRepository,
            DeviceTokenRepository deviceTokenRepository,
            PushNotificationService pushNotificationService) {
        this.projectNoteRepository = projectNoteRepository;
        this.userRepository = userRepository;
        this.deviceTokenRepository = deviceTokenRepository;
        this.pushNotificationService = pushNotificationService;
    }

    @Scheduled(cron = "${mycosplaymanager.notification.scan-cron}")
    @Transactional
    public void run() {
        Instant now = Instant.now();
        List<ProjectNote> pendingNotes = projectNoteRepository.findPending();
        int notifiedNotes = 0;

        for (ProjectNote note : pendingNotes) {
            if (now.isBefore(note.getNotifyAt())) {
                continue;
            }

            boolean notifiedSomeone = false;
            for (User member : userRepository.findByTeamId(note.getProject().getTeam().getId())) {
                for (DeviceToken deviceToken : deviceTokenRepository.findByUserId(member.getId())) {
                    pushNotificationService.send(deviceToken.getFcmToken(), note.getProject().getName(), note.getText());
                    notifiedSomeone = true;
                }
            }

            note.setNotified(true);
            projectNoteRepository.save(note);
            if (notifiedSomeone) {
                notifiedNotes++;
            }
        }

        if (notifiedNotes > 0) {
            log.info("Scheduler note progetto: inviate notifiche per {} note", notifiedNotes);
        }
    }
}
