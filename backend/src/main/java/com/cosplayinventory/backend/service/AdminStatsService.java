package com.cosplayinventory.backend.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cosplayinventory.backend.dto.AdminStatsResponse;
import com.cosplayinventory.backend.repository.InventoryItemRepository;
import com.cosplayinventory.backend.repository.ProductRepository;
import com.cosplayinventory.backend.repository.TeamRepository;
import com.cosplayinventory.backend.repository.UserRepository;

@Transactional(readOnly = true)
@Service
public class AdminStatsService {

    private final UserRepository userRepository;
    private final TeamRepository teamRepository;
    private final ProductRepository productRepository;
    private final InventoryItemRepository inventoryItemRepository;

    public AdminStatsService(
            UserRepository userRepository,
            TeamRepository teamRepository,
            ProductRepository productRepository,
            InventoryItemRepository inventoryItemRepository) {
        this.userRepository = userRepository;
        this.teamRepository = teamRepository;
        this.productRepository = productRepository;
        this.inventoryItemRepository = inventoryItemRepository;
    }

    public AdminStatsResponse get() {
        return new AdminStatsResponse(
                userRepository.count(), teamRepository.count(), productRepository.count(), inventoryItemRepository.count());
    }
}
