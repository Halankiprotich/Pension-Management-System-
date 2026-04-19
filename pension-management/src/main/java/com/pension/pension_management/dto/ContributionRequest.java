package com.pension.pension_management.dto;

import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContributionRequest {

    @NotBlank(message = "Member number is required")
    private String memberNumber;

    @Positive(message = "Amount must be greater than zero")
    @NotNull
    private BigDecimal amount;

    private String paymentMethod;

    private String referenceNumber;

    private String notes;
}
