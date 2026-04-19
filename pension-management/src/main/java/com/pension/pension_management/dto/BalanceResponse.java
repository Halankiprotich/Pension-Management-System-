package com.pension.pension_management.dto;

import lombok.*;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BalanceResponse {

    private String memberNumber;
    private String fullName;
    private BigDecimal totalContributions;
    private boolean active;
}
