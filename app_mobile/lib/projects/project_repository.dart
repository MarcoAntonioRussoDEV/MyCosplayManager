import '../core/api_client.dart';
import '../core/models/project.dart';
import '../core/models/project_material.dart';
import '../core/models/project_note.dart';

class ProjectRepository {
  final ApiClient _apiClient;

  ProjectRepository(this._apiClient);

  Future<List<Project>> list() async {
    final json = await _apiClient.get('/api/projects') as List;
    return json.map((e) => Project.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ProjectDetail> get(String id) async {
    final json = await _apiClient.get('/api/projects/$id');
    return ProjectDetail.fromJson(json as Map<String, dynamic>);
  }

  Future<Project> create({
    required String name,
    String? description,
    String? imageUrl,
    double? laborHours,
    double? laborRatePerHour,
  }) async {
    final json = await _apiClient.post('/api/projects', body: {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'laborHours': laborHours,
      'laborRatePerHour': laborRatePerHour,
    });
    return Project.fromJson(json as Map<String, dynamic>);
  }

  Future<Project> update(
    String id, {
    required String name,
    String? description,
    String? imageUrl,
    double? laborHours,
    double? laborRatePerHour,
  }) async {
    final json = await _apiClient.put('/api/projects/$id', body: {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'laborHours': laborHours,
      'laborRatePerHour': laborRatePerHour,
    });
    return Project.fromJson(json as Map<String, dynamic>);
  }

  Future<void> delete(String id) => _apiClient.delete('/api/projects/$id');

  Future<ProjectDetail> addMaterial(
    String projectId, {
    required String categoryId,
    String? productId,
    String? inventoryItemId,
    String? note,
    required double quantity,
    required String unit,
    double? price,
  }) async {
    final json = await _apiClient.post('/api/projects/$projectId/materials', body: {
      'categoryId': categoryId,
      if (productId != null) 'productId': productId,
      if (inventoryItemId != null) 'inventoryItemId': inventoryItemId,
      if (note != null && note.isNotEmpty) 'note': note,
      'quantity': quantity,
      'unit': unit,
      'price': price,
    });
    return ProjectDetail.fromJson(json as Map<String, dynamic>);
  }

  Future<ProjectDetail> updateMaterial(
    String materialId, {
    required double quantity,
    required String unit,
    double? price,
    String? note,
  }) async {
    final json = await _apiClient.put('/api/projects/materials/$materialId', body: {
      'quantity': quantity,
      'unit': unit,
      'price': price,
      'note': note,
    });
    return ProjectDetail.fromJson(json as Map<String, dynamic>);
  }

  Future<ProjectDetail> removeMaterial(String materialId) async {
    // Il backend torna il progetto ricalcolato anche per la delete: niente client DELETE
    // "silenzioso", il chiamante puo' aggiornare subito la UI col nuovo totale.
    final json = await _apiClient.delete('/api/projects/materials/$materialId');
    return ProjectDetail.fromJson(json as Map<String, dynamic>);
  }

  Future<List<ProjectNote>> listNotes(String projectId) async {
    final json = await _apiClient.get('/api/projects/$projectId/notes') as List;
    return json.map((e) => ProjectNote.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ProjectNote> addNote(
    String projectId, {
    required String text,
    required DateTime taskAt,
    required DateTime notifyAt,
  }) async {
    final json = await _apiClient.post('/api/projects/$projectId/notes', body: {
      'text': text,
      'taskAt': taskAt.toUtc().toIso8601String(),
      'notifyAt': notifyAt.toUtc().toIso8601String(),
    });
    return ProjectNote.fromJson(json as Map<String, dynamic>);
  }

  Future<ProjectNote> updateNote(
    String noteId, {
    required String text,
    required DateTime taskAt,
    required DateTime notifyAt,
  }) async {
    final json = await _apiClient.put('/api/projects/notes/$noteId', body: {
      'text': text,
      'taskAt': taskAt.toUtc().toIso8601String(),
      'notifyAt': notifyAt.toUtc().toIso8601String(),
    });
    return ProjectNote.fromJson(json as Map<String, dynamic>);
  }

  Future<ProjectNote> setNoteDone(String noteId, bool done) async {
    final json = await _apiClient.patch('/api/projects/notes/$noteId/done', body: {'done': done});
    return ProjectNote.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteNote(String noteId) => _apiClient.delete('/api/projects/notes/$noteId');
}
