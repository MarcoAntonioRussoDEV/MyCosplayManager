package com.cosplayinventory.backend.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cosplayinventory.backend.entity.Category;

public interface CategoryRepository extends JpaRepository<Category, UUID> {

    boolean existsByCode(String code);
}
