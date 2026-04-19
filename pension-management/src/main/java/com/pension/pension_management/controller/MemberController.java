package com.pension.pension_management.controller;


import com.pension.pension_management.dto.MemberRequest;
import com.pension.pension_management.dto.MemberResponse;
import com.pension.pension_management.service.MemberService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/members")
@RequiredArgsConstructor
@Tag(name = "Pension Members", description = "API for managing pension members")
public class MemberController {

    private final MemberService memberService;

    @PostMapping
    @Operation(summary = "Create a new pension member")
    public ResponseEntity<MemberResponse> createMember(@Valid @RequestBody MemberRequest request) {
        MemberResponse response = memberService.createMember(request);
        return new ResponseEntity<>(response, HttpStatus.CREATED);
    }

    @GetMapping("/{memberNumber}")
    @Operation(summary = "Get member by member number")
    public ResponseEntity<MemberResponse> getMember(@PathVariable String memberNumber) {
        MemberResponse response = memberService.getMemberByNumber(memberNumber);
        return ResponseEntity.ok(response);
    }

    @GetMapping
    @Operation(summary = "Get all members")
    public ResponseEntity<List<MemberResponse>> getAllMembers() {
        List<MemberResponse> members = memberService.getAllMembers();
        return ResponseEntity.ok(members);
    }
}
