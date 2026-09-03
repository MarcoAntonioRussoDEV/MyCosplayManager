package com.cosplayinventory.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.cosplayinventory.backend.dto.CreateShoppingListItemRequest;
import com.cosplayinventory.backend.entity.Product;
import com.cosplayinventory.backend.entity.ShoppingListItem;
import com.cosplayinventory.backend.entity.User;
import com.cosplayinventory.backend.repository.ProductRepository;
import com.cosplayinventory.backend.repository.ShoppingListItemRepository;

@Transactional(readOnly = true)
@Service
public class ShoppingListItemService {

    private final ShoppingListItemRepository shoppingListItemRepository;
    private final ProductRepository productRepository;

    public ShoppingListItemService(
            ShoppingListItemRepository shoppingListItemRepository, ProductRepository productRepository) {
        this.shoppingListItemRepository = shoppingListItemRepository;
        this.productRepository = productRepository;
    }

    public List<ShoppingListItem> listForTeam(UUID teamId) {
        return shoppingListItemRepository.findByTeamIdOrderByPurchasedAscCreatedAtDesc(teamId);
    }

    @Transactional
    public ShoppingListItem create(CreateShoppingListItemRequest request, User creator) {
        if (request.productId() == null && (request.customName() == null || request.customName().isBlank())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Serve productId oppure customName");
        }

        ShoppingListItem item = new ShoppingListItem();
        item.setTeam(creator.getTeam());
        if (request.productId() != null) {
            Product product = productRepository.findById(request.productId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prodotto non trovato"));
            item.setProduct(product);
        }
        item.setCustomName(request.customName());
        item.setQuantity(request.quantity());
        item.setUnit(request.unit());
        item.setCreatedBy(creator);
        return shoppingListItemRepository.save(item);
    }

    @Transactional
    public ShoppingListItem setPurchased(UUID id, UUID teamId, boolean purchased) {
        ShoppingListItem item = findOwned(id, teamId);
        item.setPurchased(purchased);
        return shoppingListItemRepository.save(item);
    }

    @Transactional
    public void delete(UUID id, UUID teamId) {
        shoppingListItemRepository.delete(findOwned(id, teamId));
    }

    private ShoppingListItem findOwned(UUID id, UUID teamId) {
        ShoppingListItem item = shoppingListItemRepository.findWithProductById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Voce non trovata"));
        if (!item.getTeam().getId().equals(teamId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Voce non trovata");
        }
        return item;
    }
}
