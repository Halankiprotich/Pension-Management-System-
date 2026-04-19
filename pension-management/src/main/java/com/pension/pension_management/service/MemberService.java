package com.pension.pension_management.service;

import com.pension.pension_management.dto.BalanceResponse;
import com.pension.pension_management.dto.MemberRequest;
import com.pension.pension_management.dto.MemberResponse;

import java.util.List;

public interface MemberService {
    MemberResponse createMember(MemberRequest request);
    MemberResponse getMemberByNumber(String memberNumber);
    List<MemberResponse> getAllMembers();
    BalanceResponse getMemberBalance(String memberNumber);
}
