package com.pension.pension_management.repository;

import com.pension.pension_management.entity.Contribution;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ContributionRepository extends JpaRepository<Contribution, Long> {

    List<Contribution> findByMemberNumber(String memberNumber);

    List<Contribution> findByMember_MemberNumber(String memberNumber);
}
