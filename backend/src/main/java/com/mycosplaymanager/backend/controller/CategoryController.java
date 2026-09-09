package com.mycosplaymanager.backend.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.CategoryPriceRangeResponse;
import com.mycosplaymanager.backend.dto.CategoryResponse;
import com.mycosplaymanager.backend.repository.CategoryRepository;
import com.mycosplaymanager.backend.repository.InventoryItemRepository;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryRepository categoryRepository;
    private final InventoryItemRepository inventoryItemRepository;

    public CategoryController(CategoryRepository categoryRepository, InventoryItemRepository inventoryItemRepository) {
        this.categoryRepository = categoryRepository;
        this.inventoryItemRepository = inventoryItemRepository;
    }

    /** Lista completa: il client sceglie la colonna di traduzione giusta in base alla lingua attiva. */
    @GetMapping
    public List<CategoryResponse> list() {
        return categoryRepository.findAll().stream().map(CategoryResponse::from).toList();
    }

    /** Usato dal calcolatore prezzo dei Progetti quando un materiale non ha un prezzo esplicito. */
    @GetMapping("/{id}/price-range")
    public CategoryPriceRangeResponse priceRange(@PathVariable UUID id) {
        if (!categoryRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria non trovata");
        }
        return inventoryItemRepository.findPriceRangeByCategoryId(id);
    }
}
