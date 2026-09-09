package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.mycosplaymanager.backend.entity.ShoppingListItem;

public interface ShoppingListItemRepository extends JpaRepository<ShoppingListItem, UUID> {

    // JOIN FETCH: stesso motivo di InventoryItemRepository, product va letto nel DTO
    // dopo la chiusura della sessione (open-in-view: false).
    @Query("SELECT s FROM ShoppingListItem s LEFT JOIN FETCH s.product WHERE s.team.id = :teamId "
            + "ORDER BY s.purchased ASC, s.createdAt DESC")
    List<ShoppingListItem> findByTeamIdOrderByPurchasedAscCreatedAtDesc(@Param("teamId") UUID teamId);

    @Query("SELECT s FROM ShoppingListItem s LEFT JOIN FETCH s.product WHERE s.id = :id")
    java.util.Optional<ShoppingListItem> findWithProductById(@Param("id") UUID id);
}
