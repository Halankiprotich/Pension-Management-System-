package com.pension.pension_management.service;

import com.pension.pension_management.dto.ContributionRequest;
import com.pension.pension_management.dto.ContributionResponse;
import com.pension.pension_management.entity.Contribution;
import com.pension.pension_management.entity.Member;
import com.pension.pension_management.exception.ResourceNotFoundException;
import com.pension.pension_management.repository.ContributionRepository;
import com.pension.pension_management.repository.MemberRepository;
import com.pension.pension_management.service.ContributionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ContributionServiceImpl implements ContributionService {

    private final ContributionRepository contributionRepository;
    private final MemberRepository memberRepository;

    @Override
    public ContributionResponse addContribution(ContributionRequest request) {
        // 1. Find the member by memberNumber
        Member member = memberRepository.findByMemberNumber(request.getMemberNumber())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Member not found with member number: " + request.getMemberNumber()));

        // 2. Create new contribution with explicit values
        Contribution contribution = Contribution.builder()
                .member(member)
                .memberNumber(member.getMemberNumber())
                .amount(request.getAmount())
                .contributionDate(LocalDateTime.now())           // FIXED: Explicitly set date
                .paymentMethod(request.getPaymentMethod())
                .referenceNumber(request.getReferenceNumber())
                .notes(request.getNotes())
                .build();

        // 3. Save the contribution
        Contribution savedContribution = contributionRepository.save(contribution);

        // 4. Update member's total contributions (important for balance)
        member.setTotalContributions(
                member.getTotalContributions().add(request.getAmount())
        );
        memberRepository.save(member);

        // 5. Return response
        return mapToResponse(savedContribution);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ContributionResponse> getAllContributions() {
        return contributionRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<ContributionResponse> getContributionsByMember(String memberNumber) {
        return contributionRepository.findByMemberNumber(memberNumber).stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    /**
     * Maps Contribution entity to ContributionResponse DTO
     */
    private ContributionResponse mapToResponse(Contribution contribution) {
        return ContributionResponse.builder()
                .id(contribution.getId())
                .memberNumber(contribution.getMemberNumber())
                .fullName(contribution.getMember().getFullName())
                .amount(contribution.getAmount())
                .contributionDate(contribution.getContributionDate())
                .paymentMethod(contribution.getPaymentMethod())
                .referenceNumber(contribution.getReferenceNumber())
                .notes(contribution.getNotes())
                .build();
    }
}