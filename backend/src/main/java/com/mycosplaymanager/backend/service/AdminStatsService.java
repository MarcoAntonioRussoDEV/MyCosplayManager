package com.mycosplaymanager.backend.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mycosplaymanager.backend.dto.AdminStatsResponse;
import com.mycosplaymanager.backend.repository.InventoryItemRepository;
import com.mycosplaymanager.backend.repository.ProductRepository;
import com.mycosplaymanager.backend.repository.TeamRepository;
import com.mycosplaymanager.backend.repository.UserRepository;

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
