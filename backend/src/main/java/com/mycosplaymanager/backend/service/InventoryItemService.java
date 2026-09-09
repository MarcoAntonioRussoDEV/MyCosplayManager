package com.mycosplaymanager.backend.service;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.CreateInventoryItemRequest;
import com.mycosplaymanager.backend.dto.UpdateInventoryItemRequest;
import com.mycosplaymanager.backend.entity.InventoryItem;
import com.mycosplaymanager.backend.entity.InventoryItemStatus;
import com.mycosplaymanager.backend.entity.Product;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.InventoryItemRepository;
import com.mycosplaymanager.backend.repository.ProductRepository;

// readOnly di default: le sole scritture (create/update/changeStatus/delete) si riaprono una
// transazione dedicata. Necessario anche per le sole letture: senza una transazione che copra
// find+mapping, "product" (JOIN FETCH) risulterebbe comunque riattaccato come proxy lazy da
// save()/merge() se letto e scritto in due transazioni separate — vedi changeStatus/update.
@Transactional(readOnly = true)
@Service
public class InventoryItemService {

    private final InventoryItemRepository inventoryItemRepository;
    private final ProductRepository productRepository;

    public InventoryItemService(InventoryItemRepository inventoryItemRepository, ProductRepository productRepository) {
        this.inventoryItemRepository = inventoryItemRepository;
        this.productRepository = productRepository;
    }

    public List<InventoryItem> listForTeam(UUID teamId, InventoryItemStatus statusFilter) {
        if (statusFilter != null) {
            return inventoryItemRepository.findByTeamIdAndStatusOrderByExpiryDateAscCreatedAtDesc(teamId, statusFilter);
        }
        return inventoryItemRepository.findByTeamIdOrderByExpiryDateAscCreatedAtDesc(teamId);
    }

    public InventoryItem get(UUID id, UUID teamId) {
        return findOwned(id, teamId);
    }

    @Transactional
    public InventoryItem create(CreateInventoryItemRequest request, User creator) {
        Product product = productRepository.findById(request.productId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prodotto non trovato"));

        InventoryItem item = new InventoryItem();
        item.setTeam(creator.getTeam());
        item.setProduct(product);
        item.setQuantity(request.quantity());
        item.setUnit(request.unit());
        item.setPrice(request.price());
        item.setLocationText(request.locationText());
        item.setExpiryDate(request.expiryDate());
        item.setCreatedBy(creator);
        return inventoryItemRepository.save(item);
    }

    @Transactional
    public InventoryItem update(UUID id, UUID teamId, UpdateInventoryItemRequest request) {
        InventoryItem item = findOwned(id, teamId);
        item.setQuantity(request.quantity());
        item.setUnit(request.unit());
        item.setPrice(request.price());
        item.setLocationText(request.locationText());
        item.setExpiryDate(request.expiryDate());
        item.setRemainingQuantity(request.remainingQuantity());
        return inventoryItemRepository.save(item);
    }

    @Transactional
    public InventoryItem changeStatus(UUID id, UUID teamId, InventoryItemStatus newStatus) {
        InventoryItem item = findOwned(id, teamId);
        // Prima apertura: registra la data per calcolare la scadenza effettiva
        // (min tra expiry_date stampata e opened_at + giorni di shelf-life del prodotto).
        if (newStatus == InventoryItemStatus.OPENED && item.getOpenedAt() == null) {
            item.setOpenedAt(LocalDate.now());
        }
        item.setStatus(newStatus);
        return inventoryItemRepository.save(item);
    }

    @Transactional
    public void delete(UUID id, UUID teamId) {
        InventoryItem item = findOwned(id, teamId);
        inventoryItemRepository.delete(item);
    }

    /** 404 (non 403) se l'item esiste ma appartiene a un altro team: non rivela che esiste. */
    private InventoryItem findOwned(UUID id, UUID teamId) {
        InventoryItem item = inventoryItemRepository.findWithProductById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Articolo non trovato"));
        if (!item.getTeam().getId().equals(teamId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Articolo non trovato");
        }
        return item;
    }
}
