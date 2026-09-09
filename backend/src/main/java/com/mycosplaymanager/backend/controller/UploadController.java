package com.mycosplaymanager.backend.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.mycosplaymanager.backend.dto.UploadResponse;
import com.mycosplaymanager.backend.service.UploadService;

/** Upload generico (foto prodotto, foto progetto): l'app manda il file, il backend
 * lo salva su UPLOAD_DIR e torna l'URL relativo da riusare come imageUrl. */
@RestController
@RequestMapping("/api/uploads")
public class UploadController {

    private final UploadService uploadService;

    public UploadController(UploadService uploadService) {
        this.uploadService = uploadService;
    }

    @PostMapping
    public UploadResponse upload(@RequestParam("file") MultipartFile file) {
        return new UploadResponse(uploadService.store(file));
    }
}
