package com.mycosplaymanager.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.AdminUpdateProductRequest;
import com.mycosplaymanager.backend.entity.Category;
import com.mycosplaymanager.backend.entity.Product;
import com.mycosplaymanager.backend.repository.CategoryRepository;
import com.mycosplaymanager.backend.repository.InventoryItemRepository;
import com.mycosplaymanager.backend.repository.ProductRepository;

@Transactional(readOnly = true)
@Service
public class AdminProductService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final InventoryItemRepository inventoryItemRepository;

    public AdminProductService(
            ProductRepository productRepository,
            CategoryRepository categoryRepository,
            InventoryItemRepository inventoryItemRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
        this.inventoryItemRepository = inventoryItemRepository;
    }

    public List<Product> listAll() {
        return productRepository.findAll();
    }

    @Transactional
    public Product update(UUID id, AdminUpdateProductRequest request) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prodotto non trovato"));
        product.setName(request.name());
        product.setBrand(request.brand());
        product.setDaysAfterOpening(request.daysAfterOpening());
        if (request.categoryId() != null) {
            Category category = categoryRepository.findById(request.categoryId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria non trovata"));
            product.setCategory(category);
        } else {
            product.setCategory(null);
        }
        return productRepository.save(product);
    }

    /** 409 se qualche team ha ancora un articolo di questo prodotto in inventario, invece
     * di lasciar fallire la delete sul vincolo di chiave esterna con un errore SQL grezzo. */
    @Transactional
    public void delete(UUID id) {
        if (!productRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Prodotto non trovato");
        }
        if (inventoryItemRepository.existsByProduct_Id(id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Il prodotto e' ancora usato in almeno un inventario, non puo' essere eliminato");
        }
        productRepository.deleteById(id);
    }
}
