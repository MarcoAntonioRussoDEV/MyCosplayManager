package com.mycosplaymanager.backend.entity;

import java.math.BigDecimal;
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

/** Riga del calcolatore prezzo: quantita'/prezzo sono uno snapshot al momento
 * dell'aggiunta, non legati in tempo reale all'inventario (vedi V4__projects.sql). */
@Entity
@Table(name = "project_materials")
@Getter
@Setter
@NoArgsConstructor
public class ProjectMaterial {

    @Id
    @UuidGenerator
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "project_id", nullable = false)
    private Project project;

    /** Ancora della riga: scelta esplicitamente dall'utente, usata per la stima prezzo
     * (range di categoria) quando nessun prodotto/prezzo esplicito e' indicato. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    /** Facoltativo: riferimento al catalogo o al proprio inventario per il prezzo reale. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    /** Solo tracciabilita' facoltativa: quale acquisto ha originato questo materiale. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "inventory_item_id")
    private InventoryItem inventoryItem;

    /** Nota libera, es. "cosplay shop" o "cinese". */
    private String note;

    @Column(nullable = false)
    private BigDecimal quantity;

    @Column(nullable = false)
    private String unit;

    private BigDecimal price;

    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @PrePersist
    void onCreate() {
        this.createdAt = Instant.now();
    }
}
