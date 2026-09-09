package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.mycosplaymanager.backend.entity.User;

public interface UserRepository extends JpaRepository<User, UUID> {

    Optional<User> findByEmail(String email);

    Optional<User> findByGoogleId(String googleId);

    List<User> findByTeamId(UUID teamId);

    // JOIN FETCH team: dashboard admin legge team.name subito dopo, fuori transazione.
    @Query("SELECT u FROM User u JOIN FETCH u.team ORDER BY u.createdAt DESC")
    List<User> findAllWithTeam();

    @Query("SELECT u FROM User u JOIN FETCH u.team WHERE u.id = :id")
    Optional<User> findWithTeamById(@org.springframework.data.repository.query.Param("id") UUID id);
}
