package com.pension.pension_management.dto;

import jakarta.validation.constraints.*;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberRequest {

    @NotBlank
    @Size(min = 5, max = 20)
    private String memberNumber;

    @NotBlank
    private String fullName;

    private LocalDate dateOfBirth;


    @NotBlank
    @Email
    private String email;

    private String phoneNumber;

    @NotBlank
    private String address;
}