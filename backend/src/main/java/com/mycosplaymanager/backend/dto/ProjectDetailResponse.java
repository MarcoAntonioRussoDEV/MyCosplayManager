package com.mycosplaymanager.backend.dto;

import java.math.BigDecimal;
import java.util.List;

public record ProjectDetailResponse(
        ProjectResponse project,
        List<ProjectMaterialResponse> materials,
        BigDecimal materialsCost,
        BigDecimal laborCost,
        BigDecimal totalCost) {
}
