package com.mycosplaymanager.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.CreateProductRequest;
import com.mycosplaymanager.backend.entity.Category;
import com.mycosplaymanager.backend.entity.Product;
import com.mycosplaymanager.backend.repository.CategoryRepository;
import com.mycosplaymanager.backend.repository.ProductRepository;

@Service
public class ProductService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;

    public ProductService(ProductRepository productRepository, CategoryRepository categoryRepository) {
        this.productRepository = productRepository;
        this.categoryRepository = categoryRepository;
    }

    public Product findByBarcode(String barcode) {
        return productRepository.findByBarcode(barcode)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Nessun prodotto trovato per il barcode " + barcode));
    }

    /** Ricerca libera nel catalogo crowdsourced per nome/marca, opzionalmente ristretta a una
     * categoria, es. per aggiungere un materiale a un progetto senza passare dall'inventario. */
    public List<Product> search(String query, UUID categoryId) {
        String normalizedQuery = query == null || query.isBlank() ? null : query;
        return productRepository.search(categoryId, normalizedQuery, PageRequest.of(0, 20));
    }

    /** Crea una nuova entry crowdsourced: chiamato quando lo scan non trova nulla. */
    public Product create(CreateProductRequest request) {
        if (productRepository.existsByBarcode(request.barcode())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Esiste gia' un prodotto con barcode " + request.barcode());
        }

        Product product = new Product();
        product.setBarcode(request.barcode());
        product.setName(request.name());
        product.setBrand(request.brand());
        product.setImageUrl(request.imageUrl());
        product.setDaysAfterOpening(request.daysAfterOpening());
        if (request.categoryId() != null) {
            product.setCategory(findCategory(request.categoryId()));
        }
        return productRepository.save(product);
    }

    private Category findCategory(UUID categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria non trovata"));
    }
}
