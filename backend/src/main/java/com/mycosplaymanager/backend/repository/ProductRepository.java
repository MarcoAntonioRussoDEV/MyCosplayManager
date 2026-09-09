package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.mycosplaymanager.backend.entity.Product;

public interface ProductRepository extends JpaRepository<Product, UUID> {

    Optional<Product> findByBarcode(String barcode);

    boolean existsByBarcode(String barcode);

    boolean existsByCategory_Id(UUID categoryId);

    /** Ricerca libera per nome/marca, opzionalmente ristretta a una categoria (es. per
     * scegliere un materiale-progetto coerente con la categoria scelta dall'utente). */
    // CAST(:query AS string) esplicito: senza, Postgres non riesce a dedurre il tipo del
    // parametro quando e' null (dentro LOWER/CONCAT), fallisce con "function lower(bytea)
    // does not exist" invece di trattarlo semplicemente come NULL.
    @Query("SELECT p FROM Product p WHERE (:categoryId IS NULL OR p.category.id = :categoryId) "
            + "AND (:query IS NULL OR LOWER(p.name) LIKE LOWER(CONCAT('%', CAST(:query AS string), '%')) "
            + "OR LOWER(p.brand) LIKE LOWER(CONCAT('%', CAST(:query AS string), '%')))")
    List<Product> search(@Param("categoryId") UUID categoryId, @Param("query") String query, Pageable pageable);
}
