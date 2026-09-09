package com.mycosplaymanager.backend.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.PatchMapping;

import com.mycosplaymanager.backend.dto.AddProjectMaterialRequest;
import com.mycosplaymanager.backend.dto.CreateProjectNoteRequest;
import com.mycosplaymanager.backend.dto.CreateProjectRequest;
import com.mycosplaymanager.backend.dto.ProjectDetailResponse;
import com.mycosplaymanager.backend.dto.ProjectNoteResponse;
import com.mycosplaymanager.backend.dto.ProjectResponse;
import com.mycosplaymanager.backend.dto.SetProjectNoteDoneRequest;
import com.mycosplaymanager.backend.dto.UpdateProjectMaterialRequest;
import com.mycosplaymanager.backend.dto.UpdateProjectNoteRequest;
import com.mycosplaymanager.backend.dto.UpdateProjectRequest;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.security.AuthenticatedUser;
import com.mycosplaymanager.backend.service.CurrentUserService;
import com.mycosplaymanager.backend.service.ProjectService;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/projects")
public class ProjectController {

    private final ProjectService projectService;
    private final CurrentUserService currentUserService;

    public ProjectController(ProjectService projectService, CurrentUserService currentUserService) {
        this.projectService = projectService;
        this.currentUserService = currentUserService;
    }

    @GetMapping
    public List<ProjectResponse> list(@AuthenticationPrincipal AuthenticatedUser principal) {
        User user = currentUserService.require(principal);
        return projectService.listForTeam(user.getTeam().getId()).stream().map(ProjectResponse::from).toList();
    }

    @GetMapping("/{id}")
    public ProjectDetailResponse get(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID id) {
        User user = currentUserService.require(principal);
        return projectService.getDetail(id, user.getTeam().getId());
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectResponse create(
            @AuthenticationPrincipal AuthenticatedUser principal, @Valid @RequestBody CreateProjectRequest request) {
        User user = currentUserService.require(principal);
        return ProjectResponse.from(projectService.create(request, user));
    }

    @PutMapping("/{id}")
    public ProjectResponse update(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID id,
            @Valid @RequestBody UpdateProjectRequest request) {
        User user = currentUserService.require(principal);
        return ProjectResponse.from(projectService.update(id, user.getTeam().getId(), request));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID id) {
        User user = currentUserService.require(principal);
        projectService.delete(id, user.getTeam().getId());
    }

    @PostMapping("/{id}/materials")
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectDetailResponse addMaterial(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID id,
            @Valid @RequestBody AddProjectMaterialRequest request) {
        User user = currentUserService.require(principal);
        return projectService.addMaterial(id, user.getTeam().getId(), request);
    }

    @PutMapping("/materials/{materialId}")
    public ProjectDetailResponse updateMaterial(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID materialId,
            @Valid @RequestBody UpdateProjectMaterialRequest request) {
        User user = currentUserService.require(principal);
        return projectService.updateMaterial(materialId, user.getTeam().getId(), request);
    }

    @DeleteMapping("/materials/{materialId}")
    public ProjectDetailResponse removeMaterial(
            @AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID materialId) {
        User user = currentUserService.require(principal);
        return projectService.removeMaterial(materialId, user.getTeam().getId());
    }

    @GetMapping("/{id}/notes")
    public List<ProjectNoteResponse> listNotes(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID id) {
        User user = currentUserService.require(principal);
        return projectService.listNotes(id, user.getTeam().getId());
    }

    @PostMapping("/{id}/notes")
    @ResponseStatus(HttpStatus.CREATED)
    public ProjectNoteResponse addNote(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID id,
            @Valid @RequestBody CreateProjectNoteRequest request) {
        User user = currentUserService.require(principal);
        return projectService.addNote(id, user.getTeam().getId(), request, user);
    }

    @PutMapping("/notes/{noteId}")
    public ProjectNoteResponse updateNote(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID noteId,
            @Valid @RequestBody UpdateProjectNoteRequest request) {
        User user = currentUserService.require(principal);
        return projectService.updateNote(noteId, user.getTeam().getId(), request);
    }

    @PatchMapping("/notes/{noteId}/done")
    public ProjectNoteResponse setNoteDone(
            @AuthenticationPrincipal AuthenticatedUser principal,
            @PathVariable UUID noteId,
            @Valid @RequestBody SetProjectNoteDoneRequest request) {
        User user = currentUserService.require(principal);
        return projectService.setNoteDone(noteId, user.getTeam().getId(), request);
    }

    @DeleteMapping("/notes/{noteId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteNote(@AuthenticationPrincipal AuthenticatedUser principal, @PathVariable UUID noteId) {
        User user = currentUserService.require(principal);
        projectService.deleteNote(noteId, user.getTeam().getId());
    }
}
