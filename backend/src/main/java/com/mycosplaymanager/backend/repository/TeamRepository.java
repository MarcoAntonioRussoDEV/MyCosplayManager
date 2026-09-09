package com.mycosplaymanager.backend.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.mycosplaymanager.backend.entity.Team;

public interface TeamRepository extends JpaRepository<Team, UUID> {

    boolean existsByInviteCode(String inviteCode);

    Optional<Team> findByInviteCode(String inviteCode);
}
