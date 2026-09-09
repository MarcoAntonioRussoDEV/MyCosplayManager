import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/api_client.dart';
import '../core/models/project_note.dart';
import '../l10n/app_localizations.dart';
import 'project_repository.dart';

class EditNotePage extends StatefulWidget {
  final String projectId;
  final ProjectNote? note;

  const EditNotePage({super.key, required this.projectId, this.note});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final ProjectRepository _repository;
  final _textController = TextEditingController();
  late DateTime _taskAt;
  late DateTime _notifyAt;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = ProjectRepository(context.read<AuthService>().apiClient);
    final note = widget.note;
    // Default: tra 5 minuti, comodo per testare subito una notifica senza dover
    // pensare a una data futura specifica.
    final defaultAt = DateTime.now().add(const Duration(minutes: 5));
    _taskAt = note?.taskAt ?? defaultAt;
    _notifyAt = note?.notifyAt ?? defaultAt;
    if (note != null) _textController.text = note.text;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(DateTime current, void Function(DateTime) onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked == null) return;
    onPicked(DateTime(picked.year, picked.month, picked.day, current.hour, current.minute));
  }

  Future<void> _pickTime(DateTime current, void Function(DateTime) onPicked) async {
    final picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(current));
    if (picked == null) return;
    onPicked(DateTime(current.year, current.month, current.day, picked.hour, picked.minute));
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (_textController.text.trim().isEmpty) {
      setState(() => _error = l10n.noteTextField);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final note = widget.note == null
          ? await _repository.addNote(widget.projectId,
              text: _textController.text.trim(), taskAt: _taskAt, notifyAt: _notifyAt)
          : await _repository.updateNote(widget.note!.id,
              text: _textController.text.trim(), taskAt: _taskAt, notifyAt: _notifyAt);
      if (mounted) Navigator.of(context).pop<ProjectNote>(note);
    } catch (e) {
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget _dateTimeRow({
    required String dateLabel,
    required String timeLabel,
    required DateTime value,
    required void Function(DateTime) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(dateLabel),
            subtitle: Text('${value.year}-${_twoDigits(value.month)}-${_twoDigits(value.day)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _pickDate(value, onChanged),
          ),
        ),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(timeLabel),
            subtitle: Text('${_twoDigits(value.hour)}:${_twoDigits(value.minute)}'),
            trailing: const Icon(Icons.access_time),
            onTap: () => _pickTime(value, onChanged),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.note == null ? l10n.addNote : l10n.editNote)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _textController,
            autofocus: widget.note == null,
            decoration: InputDecoration(labelText: l10n.noteTextField),
          ),
          const SizedBox(height: 16),
          Text(l10n.taskSectionLabel, style: Theme.of(context).textTheme.titleSmall),
          _dateTimeRow(
            dateLabel: l10n.taskDateField,
            timeLabel: l10n.taskTimeField,
            value: _taskAt,
            onChanged: (v) => setState(() => _taskAt = v),
          ),
          const SizedBox(height: 16),
          Text(l10n.notifySectionLabel, style: Theme.of(context).textTheme.titleSmall),
          Text(l10n.notifyExplainer, style: Theme.of(context).textTheme.bodySmall),
          _dateTimeRow(
            dateLabel: l10n.dueDateField,
            timeLabel: l10n.notifyTimeField,
            value: _notifyAt,
            onChanged: (v) => setState(() => _notifyAt = v),
          ),
          const SizedBox(height: 16),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
