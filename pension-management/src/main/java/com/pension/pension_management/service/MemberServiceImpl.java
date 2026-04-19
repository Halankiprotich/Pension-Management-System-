package com.pension.pension_management.service;

import com.pension.pension_management.dto.MemberRequest;
import com.pension.pension_management.dto.MemberResponse;
import com.pension.pension_management.entity.Member;
import com.pension.pension_management.exception.ResourceNotFoundException;
import com.pension.pension_management.repository.MemberRepository;
import com.pension.pension_management.service.MemberService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class MemberServiceImpl implements MemberService {

    private final MemberRepository memberRepository;

    @Override
    public MemberResponse createMember(MemberRequest request) {
        if (memberRepository.existsByMemberNumber(request.getMemberNumber())) {
            throw new IllegalArgumentException("Member number already exists: " + request.getMemberNumber());
        }

        Member member = Member.builder()
                .memberNumber(request.getMemberNumber())
                .fullName(request.getFullName())
                .dateOfBirth(request.getDateOfBirth())
                .email(request.getEmail())
                .phoneNumber(request.getPhoneNumber())
                .address(request.getAddress())
                .active(true)
                .totalContributions(BigDecimal.ZERO)
                .registrationDate(LocalDate.now())        // ← Explicitly set here
                .build();

        Member saved = memberRepository.save(member);
        return mapToResponse(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public MemberResponse getMemberByNumber(String memberNumber) {
        Member member = memberRepository.findByMemberNumber(memberNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with number: " + memberNumber));
        return mapToResponse(member);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MemberResponse> getAllMembers() {
        return memberRepository.findAll().stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    private MemberResponse mapToResponse(Member member) {
        return MemberResponse.builder()
                .memberNumber(member.getMemberNumber())
                .fullName(member.getFullName())
                .dateOfBirth(member.getDateOfBirth())
                .email(member.getEmail())
                .phoneNumber(member.getPhoneNumber())
                .address(member.getAddress())
                .totalContributions(member.getTotalContributions())
                .active(member.isActive())
                .registrationDate(member.getRegistrationDate())
                .build();
    }
}