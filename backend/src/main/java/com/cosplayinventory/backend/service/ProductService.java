package com.cosplayinventory.backend.service;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.cosplayinventory.backend.dto.CreateProductRequest;
import com.cosplayinventory.backend.entity.Category;
import com.cosplayinventory.backend.entity.Product;
import com.cosplayinventory.backend.repository.CategoryRepository;
import com.cosplayinventory.backend.repository.ProductRepository;

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
