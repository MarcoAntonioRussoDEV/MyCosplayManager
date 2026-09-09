package com.mycosplaymanager.backend.service;

import java.time.LocalDate;

import org.springframework.stereotype.Service;

import com.mycosplaymanager.backend.entity.InventoryItem;
import com.mycosplaymanager.backend.entity.InventoryItemStatus;

@Service
public class ExpiryCalculationService {

    /** Scadenza "reale" da usare per gli alert: se il prodotto e' stato aperto e ha una
     * shelf-life post-apertura nota, vale la piu' vicina tra quella stampata e
     * opened_at + days_after_opening (es. una colla apre bene fino al 2027 ma va usata
     * entro 30 giorni dall'apertura). Torna null se non c'e' nessuna scadenza da monitorare. */
    public LocalDate effectiveExpiryDate(InventoryItem item) {
        LocalDate printedExpiry = item.getExpiryDate();

        if (item.getStatus() != InventoryItemStatus.OPENED
                || item.getOpenedAt() == null
                || item.getProduct().getDaysAfterOpening() == null) {
            return printedExpiry;
        }

        LocalDate openingExpiry = item.getOpenedAt().plusDays(item.getProduct().getDaysAfterOpening());
        if (printedExpiry == null) {
            return openingExpiry;
        }
        return printedExpiry.isBefore(openingExpiry) ? printedExpiry : openingExpiry;
    }
}
