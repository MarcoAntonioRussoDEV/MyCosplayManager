package com.cosplayinventory.backend.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.cosplayinventory.backend.entity.InventoryItem;
import com.cosplayinventory.backend.entity.InventoryItemStatus;

public interface InventoryItemRepository extends JpaRepository<InventoryItem, UUID> {

    // JOIN FETCH product: con spring.jpa.open-in-view=false la sessione Hibernate si chiude
    // al termine della transazione del repository, prima che il controller mappi l'entity nel
    // DTO — senza fetch esplicito, leggere item.getProduct() la' fuori lancia
    // LazyInitializationException ("no Session").

    @Query("SELECT i FROM InventoryItem i JOIN FETCH i.product p LEFT JOIN FETCH p.category "
            + "WHERE i.team.id = :teamId ORDER BY i.expiryDate ASC NULLS LAST, i.createdAt DESC")
    List<InventoryItem> findByTeamIdOrderByExpiryDateAscCreatedAtDesc(@Param("teamId") UUID teamId);

    @Query("SELECT i FROM InventoryItem i JOIN FETCH i.product p LEFT JOIN FETCH p.category "
            + "WHERE i.team.id = :teamId AND i.status = :status ORDER BY i.expiryDate ASC NULLS LAST, i.createdAt DESC")
    List<InventoryItem> findByTeamIdAndStatusOrderByExpiryDateAscCreatedAtDesc(
            @Param("teamId") UUID teamId, @Param("status") InventoryItemStatus status);

    @Query("SELECT i FROM InventoryItem i JOIN FETCH i.product p LEFT JOIN FETCH p.category WHERE i.id = :id")
    Optional<InventoryItem> findWithProductById(@Param("id") UUID id);

    @Query("SELECT i FROM InventoryItem i JOIN FETCH i.product p LEFT JOIN FETCH p.category "
            + "WHERE i.team.id = :teamId AND i.status NOT IN :excludedStatuses AND i.expiryDate <= :expiryDate")
    List<InventoryItem> findByTeamIdAndStatusNotInAndExpiryDateLessThanEqual(
            @Param("teamId") UUID teamId,
            @Param("excludedStatuses") List<InventoryItemStatus> excludedStatuses,
            @Param("expiryDate") LocalDate expiryDate);

    /** Usata dallo scheduler notifiche: tutti gli item ancora attivi (di tutti i team) con scadenza impostata. */
    @Query("SELECT i FROM InventoryItem i JOIN FETCH i.product p LEFT JOIN FETCH p.category JOIN FETCH i.team "
            + "WHERE i.status NOT IN :excludedStatuses AND i.expiryDate IS NOT NULL")
    List<InventoryItem> findByStatusNotInAndExpiryDateIsNotNull(@Param("excludedStatuses") List<InventoryItemStatus> excludedStatuses);

    /** Usata dalla dashboard admin prima di cancellare un prodotto crowdsourced errato. */
    boolean existsByProduct_Id(UUID productId);
}
