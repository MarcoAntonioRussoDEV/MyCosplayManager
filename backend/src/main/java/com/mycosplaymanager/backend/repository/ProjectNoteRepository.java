package com.mycosplaymanager.backend.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.mycosplaymanager.backend.entity.ProjectNote;

public interface ProjectNoteRepository extends JpaRepository<ProjectNote, UUID> {

    @Query("SELECT n FROM ProjectNote n JOIN FETCH n.project WHERE n.project.id = :projectId ORDER BY n.notifyAt ASC")
    List<ProjectNote> findByProjectIdOrderByNotifyAt(@Param("projectId") UUID projectId);

    @Query("SELECT n FROM ProjectNote n JOIN FETCH n.project WHERE n.id = :id")
    Optional<ProjectNote> findWithProjectById(@Param("id") UUID id);

    /** Usata dallo scheduler notifiche: note non completate e non ancora notificate. */
    @Query("SELECT n FROM ProjectNote n JOIN FETCH n.project p JOIN FETCH p.team WHERE n.done = false AND n.notified = false")
    List<ProjectNote> findPending();
}
