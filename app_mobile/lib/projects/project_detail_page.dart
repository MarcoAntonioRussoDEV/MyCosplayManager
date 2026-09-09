import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/api_client.dart';
import '../core/models/project_material.dart';
import '../core/models/project_note.dart';
import '../l10n/app_localizations.dart';
import 'add_material_page.dart';
import 'edit_note_page.dart';
import 'edit_project_page.dart';
import 'project_repository.dart';

class ProjectDetailPage extends StatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late final ProjectRepository _repository;
  Future<ProjectDetail>? _future;
  Future<List<ProjectNote>>? _notesFuture;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _repository = ProjectRepository(context.read<AuthService>().apiClient);
    _load();
    _loadNotes();
  }

  void _load() {
    setState(() {
      _future = _repository.get(widget.projectId);
    });
  }

  void _loadNotes() {
    setState(() {
      _notesFuture = _repository.listNotes(widget.projectId);
    });
  }

  Future<void> _editProject(ProjectDetail detail) async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => EditProjectPage(project: detail.project)),
    );
    if (updated == true) {
      _changed = true;
      _load();
    }
  }

  Future<void> _deleteProject() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteProject),
        content: Text(l10n.confirmDeleteProjectMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed != true) return;
    await _repository.delete(widget.projectId);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _addMaterial() async {
    final detail = await Navigator.of(context).push<ProjectDetail>(
      MaterialPageRoute(builder: (_) => AddMaterialPage(projectId: widget.projectId)),
    );
    if (detail != null) {
      _changed = true;
      setState(() {
        _future = Future.value(detail);
      });
    }
  }

  Future<void> _removeMaterial(ProjectMaterial material) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMaterial),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed != true) return;
    final detail = await _repository.removeMaterial(material.id);
    _changed = true;
    setState(() {
      _future = Future.value(detail);
    });
  }

  Future<void> _addNote() async {
    final note = await Navigator.of(context).push<ProjectNote>(
      MaterialPageRoute(builder: (_) => EditNotePage(projectId: widget.projectId)),
    );
    if (note != null) {
      _changed = true;
      _loadNotes();
    }
  }

  Future<void> _editNote(ProjectNote note) async {
    final updated = await Navigator.of(context).push<ProjectNote>(
      MaterialPageRoute(builder: (_) => EditNotePage(projectId: widget.projectId, note: note)),
    );
    if (updated != null) {
      _changed = true;
      _loadNotes();
    }
  }

  Future<void> _toggleNoteDone(ProjectNote note, bool done) async {
    await _repository.setNoteDone(note.id, done);
    _changed = true;
    _loadNotes();
  }

  Future<void> _deleteNote(ProjectNote note) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteNoteConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (confirmed != true) return;
    await _repository.deleteNote(note.id);
    _changed = true;
    _loadNotes();
  }

  Future<void> _showAddMenu() async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(l10n.addMaterial),
              onTap: () => Navigator.of(context).pop('material'),
            ),
            ListTile(
              leading: const Icon(Icons.event_note_outlined),
              title: Text(l10n.addNote),
              onTap: () => Navigator.of(context).pop('note'),
            ),
          ],
        ),
      ),
    );
    if (choice == 'material') {
      await _addMaterial();
    } else if (choice == 'note') {
      await _addNote();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.of(context).pop(_changed);
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: _deleteProject),
          ],
        ),
        body: FutureBuilder<ProjectDetail>(
          future: _future,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              if (snapshot.hasError) {
                final message =
                    snapshot.error is ApiException ? (snapshot.error as ApiException).message : l10n.errorGeneric;
                return Center(child: Text(message));
              }
              return const Center(child: CircularProgressIndicator());
            }
            final detail = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    if (detail.project.imageUrl != null)
                      CircleAvatar(radius: 32, backgroundImage: NetworkImage('$apiBaseUrl${detail.project.imageUrl}')),
                    if (detail.project.imageUrl != null) const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(detail.project.name, style: Theme.of(context).textTheme.titleLarge),
                          if (detail.project.description != null) Text(detail.project.description!),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => _editProject(detail)),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _costRow(l10n.materialsCost, detail.materialsCost),
                        _costRow(l10n.laborCost, detail.laborCost),
                        const Divider(),
                        _costRow(l10n.totalCost, detail.totalCost, emphasize: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.materials, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...detail.materials.map((m) {
                  final languageCode = Localizations.localeOf(context).languageCode;
                  final title = m.product?.name ?? m.category?.nameFor(languageCode) ?? l10n.materials;
                  final subtitleParts = <String>[
                    '${m.quantity} ${m.unit}',
                    if (m.price != null) '€${m.price!.toStringAsFixed(2)}' else l10n.estimatedFromCategory,
                    if (m.note != null && m.note!.isNotEmpty) m.note!,
                  ];
                  return Card(
                    child: ListTile(
                      title: Text(title),
                      subtitle: Text(subtitleParts.join(' · ')),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeMaterial(m),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Text(l10n.notesSection, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                FutureBuilder<List<ProjectNote>>(
                  future: _notesFuture,
                  builder: (context, noteSnapshot) {
                    if (!noteSnapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final notes = noteSnapshot.data!;
                    if (notes.isEmpty) {
                      return Text(l10n.noNotes);
                    }
                    return Column(
                      children: notes
                          .map((note) => Card(
                                child: ListTile(
                                  leading: Checkbox(
                                    value: note.done,
                                    onChanged: (value) => _toggleNoteDone(note, value ?? false),
                                  ),
                                  title: Text(
                                    note.text,
                                    style: note.done ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
                                  ),
                                  subtitle: Text(_formatNotifyAt(note.notifyAt)),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _deleteNote(note),
                                  ),
                                  onTap: () => _editNote(note),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: _showAddMenu, child: const Icon(Icons.add)),
      ),
    );
  }

  String _formatNotifyAt(DateTime dateTime) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${two(dateTime.month)}-${two(dateTime.day)} ${two(dateTime.hour)}:${two(dateTime.minute)}';
  }

  Widget _costRow(String label, double value, {bool emphasize = false}) {
    final style = emphasize ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('€${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}
