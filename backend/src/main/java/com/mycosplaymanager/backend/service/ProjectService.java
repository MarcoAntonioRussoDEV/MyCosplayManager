package com.mycosplaymanager.backend.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.mycosplaymanager.backend.dto.AddProjectMaterialRequest;
import com.mycosplaymanager.backend.dto.CategoryPriceRangeResponse;
import com.mycosplaymanager.backend.dto.CreateProjectNoteRequest;
import com.mycosplaymanager.backend.dto.CreateProjectRequest;
import com.mycosplaymanager.backend.dto.ProjectDetailResponse;
import com.mycosplaymanager.backend.dto.ProjectMaterialResponse;
import com.mycosplaymanager.backend.dto.ProjectNoteResponse;
import com.mycosplaymanager.backend.dto.ProjectResponse;
import com.mycosplaymanager.backend.dto.SetProjectNoteDoneRequest;
import com.mycosplaymanager.backend.dto.UpdateProjectMaterialRequest;
import com.mycosplaymanager.backend.dto.UpdateProjectNoteRequest;
import com.mycosplaymanager.backend.dto.UpdateProjectRequest;
import com.mycosplaymanager.backend.entity.Category;
import com.mycosplaymanager.backend.entity.InventoryItem;
import com.mycosplaymanager.backend.entity.Product;
import com.mycosplaymanager.backend.entity.Project;
import com.mycosplaymanager.backend.entity.ProjectMaterial;
import com.mycosplaymanager.backend.entity.ProjectNote;
import com.mycosplaymanager.backend.entity.User;
import com.mycosplaymanager.backend.repository.CategoryRepository;
import com.mycosplaymanager.backend.repository.InventoryItemRepository;
import com.mycosplaymanager.backend.repository.ProductRepository;
import com.mycosplaymanager.backend.repository.ProjectMaterialRepository;
import com.mycosplaymanager.backend.repository.ProjectNoteRepository;
import com.mycosplaymanager.backend.repository.ProjectRepository;

@Transactional(readOnly = true)
@Service
public class ProjectService {

    private final ProjectRepository projectRepository;
    private final ProjectMaterialRepository projectMaterialRepository;
    private final ProductRepository productRepository;
    private final InventoryItemRepository inventoryItemRepository;
    private final CategoryRepository categoryRepository;
    private final ProjectNoteRepository projectNoteRepository;

    public ProjectService(
            ProjectRepository projectRepository,
            ProjectMaterialRepository projectMaterialRepository,
            ProductRepository productRepository,
            InventoryItemRepository inventoryItemRepository,
            CategoryRepository categoryRepository,
            ProjectNoteRepository projectNoteRepository) {
        this.projectRepository = projectRepository;
        this.projectMaterialRepository = projectMaterialRepository;
        this.productRepository = productRepository;
        this.inventoryItemRepository = inventoryItemRepository;
        this.categoryRepository = categoryRepository;
        this.projectNoteRepository = projectNoteRepository;
    }

    public List<Project> listForTeam(UUID teamId) {
        return projectRepository.findByTeamIdOrderByCreatedAtDesc(teamId);
    }

    public ProjectDetailResponse getDetail(UUID id, UUID teamId) {
        Project project = findOwned(id, teamId);
        List<ProjectMaterial> materials = projectMaterialRepository.findByProjectIdWithProduct(id);
        return buildDetail(project, materials);
    }

    @Transactional
    public Project create(CreateProjectRequest request, User creator) {
        Project project = new Project();
        project.setTeam(creator.getTeam());
        project.setName(request.name());
        project.setDescription(request.description());
        project.setImageUrl(request.imageUrl());
        project.setLaborHours(request.laborHours());
        project.setLaborRatePerHour(request.laborRatePerHour());
        project.setCreatedBy(creator);
        return projectRepository.save(project);
    }

    @Transactional
    public Project update(UUID id, UUID teamId, UpdateProjectRequest request) {
        Project project = findOwned(id, teamId);
        project.setName(request.name());
        project.setDescription(request.description());
        project.setImageUrl(request.imageUrl());
        project.setLaborHours(request.laborHours());
        project.setLaborRatePerHour(request.laborRatePerHour());
        return projectRepository.save(project);
    }

    @Transactional
    public void delete(UUID id, UUID teamId) {
        projectRepository.delete(findOwned(id, teamId));
    }

    @Transactional
    public ProjectDetailResponse addMaterial(UUID projectId, UUID teamId, AddProjectMaterialRequest request) {
        Project project = findOwned(projectId, teamId);
        Category category = categoryRepository.findById(request.categoryId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Categoria non trovata"));

        InventoryItem inventoryItem = null;
        Product product = null;
        if (request.inventoryItemId() != null) {
            inventoryItem = findOwnedInventoryItem(request.inventoryItemId(), teamId);
            product = inventoryItem.getProduct();
        } else if (request.productId() != null) {
            product = productRepository.findById(request.productId())
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Prodotto non trovato"));
        }

        ProjectMaterial material = new ProjectMaterial();
        material.setProject(project);
        material.setCategory(category);
        material.setProduct(product);
        material.setInventoryItem(inventoryItem);
        material.setNote(request.note());
        material.setQuantity(request.quantity());
        material.setUnit(request.unit());
        material.setPrice(request.price());
        projectMaterialRepository.save(material);

        List<ProjectMaterial> materials = projectMaterialRepository.findByProjectIdWithProduct(projectId);
        return buildDetail(project, materials);
    }

    @Transactional
    public ProjectDetailResponse updateMaterial(UUID materialId, UUID teamId, UpdateProjectMaterialRequest request) {
        ProjectMaterial material = findOwnedMaterial(materialId, teamId);
        material.setQuantity(request.quantity());
        material.setUnit(request.unit());
        material.setPrice(request.price());
        material.setNote(request.note());
        projectMaterialRepository.save(material);

        Project project = material.getProject();
        List<ProjectMaterial> materials = projectMaterialRepository.findByProjectIdWithProduct(project.getId());
        return buildDetail(project, materials);
    }

    @Transactional
    public ProjectDetailResponse removeMaterial(UUID materialId, UUID teamId) {
        ProjectMaterial material = findOwnedMaterial(materialId, teamId);
        Project project = material.getProject();
        projectMaterialRepository.delete(material);

        List<ProjectMaterial> materials = projectMaterialRepository.findByProjectIdWithProduct(project.getId());
        return buildDetail(project, materials);
    }

    public List<ProjectNoteResponse> listNotes(UUID projectId, UUID teamId) {
        findOwned(projectId, teamId);
        return projectNoteRepository.findByProjectIdOrderByNotifyAt(projectId).stream()
                .map(ProjectNoteResponse::from)
                .toList();
    }

    @Transactional
    public ProjectNoteResponse addNote(UUID projectId, UUID teamId, CreateProjectNoteRequest request, User creator) {
        Project project = findOwned(projectId, teamId);
        ProjectNote note = new ProjectNote();
        note.setProject(project);
        note.setText(request.text());
        note.setTaskAt(request.taskAt());
        note.setNotifyAt(request.notifyAt());
        note.setCreatedBy(creator);
        return ProjectNoteResponse.from(projectNoteRepository.save(note));
    }

    @Transactional
    public ProjectNoteResponse updateNote(UUID noteId, UUID teamId, UpdateProjectNoteRequest request) {
        ProjectNote note = findOwnedNote(noteId, teamId);
        note.setText(request.text());
        note.setTaskAt(request.taskAt());
        note.setNotifyAt(request.notifyAt());
        // L'istante e' cambiato: la notifica one-shot puo' ripartire per il nuovo orario.
        note.setNotified(false);
        return ProjectNoteResponse.from(projectNoteRepository.save(note));
    }

    @Transactional
    public ProjectNoteResponse setNoteDone(UUID noteId, UUID teamId, SetProjectNoteDoneRequest request) {
        ProjectNote note = findOwnedNote(noteId, teamId);
        note.setDone(request.done());
        return ProjectNoteResponse.from(projectNoteRepository.save(note));
    }

    @Transactional
    public void deleteNote(UUID noteId, UUID teamId) {
        projectNoteRepository.delete(findOwnedNote(noteId, teamId));
    }

    private ProjectNote findOwnedNote(UUID noteId, UUID teamId) {
        ProjectNote note = projectNoteRepository.findWithProjectById(noteId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Nota non trovata"));
        if (!note.getProject().getTeam().getId().equals(teamId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Nota non trovata");
        }
        return note;
    }

    private ProjectDetailResponse buildDetail(Project project, List<ProjectMaterial> materials) {
        BigDecimal materialsCost = BigDecimal.ZERO;
        List<ProjectMaterialResponse> materialResponses = materials.stream().map(ProjectMaterialResponse::from).toList();

        for (ProjectMaterial material : materials) {
            if (material.getPrice() != null) {
                materialsCost = materialsCost.add(material.getPrice());
                continue;
            }
            // Nessun prezzo esplicito per questa riga: stima grezza con la media dei prezzi
            // segnalati per la categoria scelta (nessuna categoria/nessun dato = 0).
            if (material.getCategory() != null) {
                CategoryPriceRangeResponse range =
                        inventoryItemRepository.findPriceRangeByCategoryId(material.getCategory().getId());
                if (range != null && range.avg() != null) {
                    materialsCost = materialsCost.add(BigDecimal.valueOf(range.avg()).setScale(2, RoundingMode.HALF_UP));
                }
            }
        }

        BigDecimal laborCost = BigDecimal.ZERO;
        if (project.getLaborHours() != null && project.getLaborRatePerHour() != null) {
            laborCost = project.getLaborHours().multiply(project.getLaborRatePerHour());
        }

        return new ProjectDetailResponse(
                ProjectResponse.from(project), materialResponses, materialsCost, laborCost, materialsCost.add(laborCost));
    }

    private Project findOwned(UUID id, UUID teamId) {
        Project project = projectRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Progetto non trovato"));
        if (!project.getTeam().getId().equals(teamId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Progetto non trovato");
        }
        return project;
    }

    private ProjectMaterial findOwnedMaterial(UUID materialId, UUID teamId) {
        ProjectMaterial material = projectMaterialRepository.findWithProductAndProjectById(materialId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Materiale non trovato"));
        if (!material.getProject().getTeam().getId().equals(teamId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Materiale non trovato");
        }
        return material;
    }

    private InventoryItem findOwnedInventoryItem(UUID inventoryItemId, UUID teamId) {
        InventoryItem item = inventoryItemRepository.findWithProductById(inventoryItemId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Articolo inventario non trovato"));
        if (!item.getTeam().getId().equals(teamId)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Articolo inventario non trovato");
        }
        return item;
    }
}
