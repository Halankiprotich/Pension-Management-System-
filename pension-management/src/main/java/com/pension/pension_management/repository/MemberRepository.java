package com.pension.pension_management.repository;

import com.pension.pension_management.entity.Member;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MemberRepository extends JpaRepository<Member, Long> {

    Optional<Member> findByMemberNumber(String memberNumber);

    boolean existsByMemberNumber(String memberNumber);
}