package com.mycosplaymanager.backend.entity;

import java.time.Instant;
import java.util.UUID;

import org.hibernate.annotations.UuidGenerator;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.PrePersist;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/** Nota/task schedulata su un progetto (es. "16/09 18:00: seconda mano di primer"). Due
 * istanti indipendenti: taskAt (quando va svolto il compito) e notifyAt (quando arriva il
 * promemoria push, non necessariamente lo stesso momento — es. compito il 30/09 10:00,
 * notifica la sera prima). Notifica one-shot (flag `notified`, non un dedupe giornaliero
 * come ExpiryNotificationScheduler): parte una volta sola al raggiungimento di notifyAt. */
@Entity
@Table(name = "project_notes")
@Getter
@Setter
@NoArgsConstructor
public class ProjectNote {

    @Id
    @UuidGenerator
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    @Column(nullable = false)
    private String text;

    @Column(name = "task_at", nullable = false)
    private Instant taskAt;

    @Column(name = "notify_at", nullable = false)
    private Instant notifyAt;

    @Column(nullable = false)
    private boolean done = false;

    @Column(nullable = false)
    private boolean notified = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @PrePersist
    void onCreate() {
        this.createdAt = Instant.now();
    }
}
