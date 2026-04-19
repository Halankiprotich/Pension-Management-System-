package com.pension.pension_management.controller;

import com.pension.pension_management.dto.ContributionRequest;
import com.pension.pension_management.dto.ContributionResponse;
import com.pension.pension_management.service.ContributionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/contributions")
@RequiredArgsConstructor
@Tag(name = "Contributions", description = "API for managing pension contributions")
public class ContributionController {

    private final ContributionService contributionService;

    @PostMapping
    @Operation(summary = "Add a new contribution for a member")
    public ResponseEntity<ContributionResponse> addContribution(@Valid @RequestBody ContributionRequest request) {
        ContributionResponse response = contributionService.addContribution(request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping
    @Operation(summary = "Get all contributions")
    public ResponseEntity<List<ContributionResponse>> getAllContributions() {
        List<ContributionResponse> contributions = contributionService.getAllContributions();
        return ResponseEntity.ok(contributions);
    }

    @GetMapping("/member/{memberNumber}")
    @Operation(summary = "Get contributions by member number")
    public ResponseEntity<List<ContributionResponse>> getContributionsByMember(@PathVariable String memberNumber) {
        List<ContributionResponse> contributions = contributionService.getContributionsByMember(memberNumber);
        return ResponseEntity.ok(contributions);
    }
}
