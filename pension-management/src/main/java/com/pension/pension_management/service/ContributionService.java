package com.pension.pension_management.service;

import com.pension.pension_management.dto.ContributionRequest;
import com.pension.pension_management.dto.ContributionResponse;

import java.util.List;

public interface ContributionService {
    ContributionResponse addContribution(ContributionRequest request);
    List<ContributionResponse> getAllContributions();
    List<ContributionResponse> getContributionsByMember(String memberNumber);
}