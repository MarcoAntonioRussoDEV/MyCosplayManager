package com.mycosplaymanager.backend.service;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.AdminCreateCategoryRequest;
import com.mycosplaymanager.backend.dto.AdminUpdateCategoryRequest;
import com.mycosplaymanager.backend.entity.Category;
import com.mycosplaymanager.backend.repository.CategoryRepository;
import com.mycosplaymanager.backend.repository.ProductRepository;

@Transactional(readOnly = true)
@Service
public class AdminCategoryService {

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;

    public AdminCategoryService(CategoryRepository categoryRepository, ProductRepository productRepository) {
        this.categoryRepository = categoryRepository;
        this.productRepository = productRepository;
    }

    public List<Category> listAll() {
        return categoryRepository.findAll();
    }

    @Transactional
    public Category create(AdminCreateCategoryRequest request) {
        if (categoryRepository.existsByCode(request.code())) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Esiste gia' una categoria con codice " + request.code());
        }
        Category category = new Category();
        category.setCode(request.code());
        category.setNameIt(request.nameIt());
        category.setNameEn(request.nameEn());
        category.setNameEs(request.nameEs());
        category.setNameFr(request.nameFr());
        return categoryRepository.save(category);
    }

    @Transactional
    public Category update(UUID id, AdminUpdateCategoryRequest request) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria non trovata"));
        category.setNameIt(request.nameIt());
        category.setNameEn(request.nameEn());
        category.setNameEs(request.nameEs());
        category.setNameFr(request.nameFr());
        return categoryRepository.save(category);
    }

    @Transactional
    public void delete(UUID id) {
        if (!categoryRepository.existsById(id)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria non trovata");
        }
        if (productRepository.existsByCategory_Id(id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "Ci sono ancora prodotti in questa categoria, non puo' essere eliminata");
        }
        categoryRepository.deleteById(id);
    }
}
