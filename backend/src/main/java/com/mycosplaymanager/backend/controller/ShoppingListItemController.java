package com.mycosplaymanager.backend.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.mycosplaymanager.backend.dto.CreateShoppingListItemRequest;
import com.mycosplaymanager.backend.dto.SetShoppingListItemPurchasedRequest;
import com.mycosplaymanager.backend.dto.ShoppingListItemResponse;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.security.AuthenticatedUser;
import com.mycosplaymanager.backend.service.CurrentUserService;
import com.mycosplaymanager.backend.service.ShoppingListItemService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/shopping-list")
public class ShoppingListItemController {

    private final ShoppingListItemService shoppingListItemService;
    private final CurrentUserService currentUserService;

    public ShoppingListItemController(
            ShoppingListItemService shoppingListItemService, CurrentUserService currentUserService) {
        this.shoppingListItemService = shoppingListItemService;
        this.currentUserService = currentUserService;
    }

    @GetMapping
    public List<ShoppingListItemResponse> list(@AuthenticationPrincipal AuthenticatedUser principal) {
        User user = currentUserService.require(principal);
        return shoppingListItemService.listForTeam(user.getTeam().getId()).stream()
                .map(ShoppingListItemResponse::from)
                .toList();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ShoppingListItemResponse create(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @Valid @RequestBody CreateShoppingListItemRequest request) {
        User user = currentUserService.require(principal);
        return ShoppingListItemResponse.from(shoppingListItemService.create(request, user));
    }

    @PatchMapping("/{id}/purchased")
    public ShoppingListItemResponse setPurchased(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID id,
            @Valid @RequestBody SetShoppingListItemPurchasedRequest request) {
        User user = currentUserService.require(principal);
        return ShoppingListItemResponse.from(
                shoppingListItemService.setPurchased(id, user.getTeam().getId(), request.purchased()));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID id) {
        User user = currentUserService.require(principal);
        shoppingListItemService.delete(id, user.getTeam().getId());
    }
}
