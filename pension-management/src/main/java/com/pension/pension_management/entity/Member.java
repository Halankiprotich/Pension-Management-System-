package com.pension.pension_management.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "pension_members")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "member_number", nullable = false, unique = true, length = 20)
    @NotBlank
    private String memberNumber;

    @Column(nullable = false, length = 100)
    @NotBlank
    private String fullName;

    @Column(nullable = false)
    @Past
    private LocalDate dateOfBirth;

    @Column(nullable = false, length = 100)
    @Email
    @NotBlank
    private String email;

    @Column(length = 20)
    private String phoneNumber;

    @Column(nullable = false)
    @NotBlank
    private String address;

    @Column(precision = 15, scale = 2)
    private BigDecimal totalContributions = BigDecimal.ZERO;

    @Column(nullable = false)
    private boolean active = true;

    // FIXED: This is the main problem
    @Column(name = "registration_date", nullable = false, updatable = false)
    private LocalDate registrationDate = LocalDate.now();

    // Add this inside Member class
    @OneToMany(mappedBy = "member", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Contribution> contributions = new ArrayList<>();
}