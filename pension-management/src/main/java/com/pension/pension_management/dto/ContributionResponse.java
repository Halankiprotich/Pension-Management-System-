package com.pension.pension_management.dto;


import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ContributionResponse {
    private Long id;
    private String memberNumber;
    private String fullName;
    private BigDecimal amount;
    private LocalDateTime contributionDate;
    private String paymentMethod;
    private String referenceNumber;
    private String notes;
}