package com.cosplayinventory.backend.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.cosplayinventory.backend.dto.ChangeInventoryItemStatusRequest;
import com.cosplayinventory.backend.dto.CreateInventoryItemRequest;
import com.cosplayinventory.backend.dto.InventoryItemResponse;
import com.cosplayinventory.backend.dto.UpdateInventoryItemRequest;
import com.cosplayinventory.backend.entity.InventoryItemStatus;
import com.cosplayinventory.backend.entity.User;
import com.cosplayinventory.backend.security.AuthenticatedUser;
import com.cosplayinventory.backend.service.CurrentUserService;
import com.cosplayinventory.backend.service.InventoryItemService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/inventory")
public class InventoryItemController {

    private final InventoryItemService inventoryItemService;
    private final CurrentUserService currentUserService;

    public InventoryItemController(InventoryItemService inventoryItemService, CurrentUserService currentUserService) {
        this.inventoryItemService = inventoryItemService;
        this.currentUserService = currentUserService;
    }

    @GetMapping
    public List<InventoryItemResponse> list(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @RequestParam(required = false) InventoryItemStatus status) {
        User user = currentUserService.require(principal);
        return inventoryItemService.listForTeam(user.getTeam().getId(), status).stream()
                .map(InventoryItemResponse::from)
                .toList();
    }

    @GetMapping("/{id}")
    public InventoryItemResponse get(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID id) {
        User user = currentUserService.require(principal);
        return InventoryItemResponse.from(inventoryItemService.get(id, user.getTeam().getId()));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public InventoryItemResponse create(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody CreateInventoryItemRequest request) {
        User user = currentUserService.require(principal);
        return InventoryItemResponse.from(inventoryItemService.create(request, user));
    }

    @PutMapping("/{id}")
    public InventoryItemResponse update(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateInventoryItemRequest request) {
        User user = currentUserService.require(principal);
        return InventoryItemResponse.from(inventoryItemService.update(id, user.getTeam().getId(), request));
    }

    @PatchMapping("/{id}/status")
    public InventoryItemResponse changeStatus(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID id,
            @Valid @RequestBody ChangeInventoryItemStatusRequest request) {
        User user = currentUserService.require(principal);
        return InventoryItemResponse.from(
                inventoryItemService.changeStatus(id, user.getTeam().getId(), request.status()));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID id) {
        User user = currentUserService.require(principal);
        inventoryItemService.delete(id, user.getTeam().getId());
    }
}
