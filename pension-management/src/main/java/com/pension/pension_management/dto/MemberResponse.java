package com.pension.pension_management.dto;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberResponse {
    private String memberNumber;
    private String fullName;
    private LocalDate dateOfBirth;
    private String email;
    private String phoneNumber;
    private String address;
    private BigDecimal totalContributions;
    private boolean active;
    private LocalDate registrationDate;
}