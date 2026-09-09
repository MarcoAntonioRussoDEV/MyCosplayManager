package com.mycosplaymanager.backend.dto;

import java.time.Instant;
import java.util.UUID;

import com.mycosplaymanager.backend.entity.ProjectNote;

public record ProjectNoteResponse(UUID id, String text, Instant notifyAt, boolean done) {

    public static ProjectNoteResponse from(ProjectNote note) {
        return new ProjectNoteResponse(note.getId(), note.getText(), note.getNotifyAt(), note.isDone());
    }
}
