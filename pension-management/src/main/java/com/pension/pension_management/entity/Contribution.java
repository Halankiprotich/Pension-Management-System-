package com.pension.pension_management.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "contributions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Contribution {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(name = "member_number", nullable = false, length = 20)
    private String memberNumber;

    @Column(nullable = false, precision = 15, scale = 2)
    private BigDecimal amount;

    // FIXED: This is the main issue
    @Column(name = "contribution_date", nullable = false, updatable = false)
    private LocalDateTime contributionDate = LocalDateTime.now();

    @Column(length = 100)
    private String paymentMethod;

    @Column(length = 255)
    private String referenceNumber;

    @Column(length = 500)
    private String notes;
}