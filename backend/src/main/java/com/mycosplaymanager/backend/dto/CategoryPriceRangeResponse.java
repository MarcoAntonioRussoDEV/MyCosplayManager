package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;

/** Calcolato al volo dai prezzi segnalati dagli utenti (inventory_items.price), non
 * un campo salvato: nessun dato se nessun team ha ancora comprato nulla in questa categoria. */
public record CategoryPriceRangeResponse(BigDecimal min, BigDecimal max, Double avg) {
}
