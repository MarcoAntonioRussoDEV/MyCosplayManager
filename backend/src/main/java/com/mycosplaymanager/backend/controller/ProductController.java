package com.mycosplaymanager.backend.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.CreateProductRequest;
import com.mycosplaymanager.backend.dto.ProductResponse;
import com.mycosplaymanager.backend.service.ProductService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    /** Chiamato dopo lo scan barcode: 404 se non e' mai stato inserito da nessun team. */
    @GetMapping("/{barcode}")
    public ProductResponse getByBarcode(@PathVariable String barcode) {
        return ProductResponse.from(productService.findByBarcode(barcode));
    }

    /** Ricerca nel catalogo per nome/marca, opzionalmente ristretta a una categoria (es. per
     * scegliere un materiale-progetto coerente con la categoria scelta dall'utente). */
    @GetMapping("/search")
    public List<ProductResponse> search(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) UUID categoryId) {
        return productService.search(q, categoryId).stream().map(ProductResponse::from).toList();
    }

    /** L'app lo chiama quando lo scan non trova nulla e l'utente compila la scheda a mano. */
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProductResponse create(@Valid @RequestBody CreateProductRequest request) {
        return ProductResponse.from(productService.create(request));
    }
}
