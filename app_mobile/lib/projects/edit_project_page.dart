import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/api_client.dart';
import '../core/models/project.dart';
import '../core/upload_repository.dart';
import '../l10n/app_localizations.dart';
import 'project_repository.dart';

/// Crea un progetto nuovo se [project] e' null, altrimenti lo modifica.
class EditProjectPage extends StatefulWidget {
  final Project? project;

  const EditProjectPage({super.key, this.project});

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  late final ProjectRepository _projectRepository;
  late final UploadRepository _uploadRepository;

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _laborHoursController;
  late final TextEditingController _laborRateController;

  String? _imageUrl;
  File? _pickedImage;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.project != null;

  @override
  void initState() {
    super.initState();
    final apiClient = context.read<AuthService>().apiClient;
    _projectRepository = ProjectRepository(apiClient);
    _uploadRepository = UploadRepository(apiClient);

    final project = widget.project;
    _nameController = TextEditingController(text: project?.name ?? '');
    _descriptionController = TextEditingController(text: project?.description ?? '');
    _laborHoursController = TextEditingController(text: project?.laborHours?.toString() ?? '');
    _laborRateController = TextEditingController(text: project?.laborRatePerHour?.toString() ?? '');
    _imageUrl = project?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _laborHoursController.dispose();
    _laborRateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1600);
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _error = AppLocalizations.of(context)!.projectName);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      String? imageUrl = _imageUrl;
      if (_pickedImage != null) {
        imageUrl = await _uploadRepository.uploadImage(_pickedImage!);
      }
      final laborHours = double.tryParse(_laborHoursController.text.replaceAll(',', '.'));
      final laborRate = double.tryParse(_laborRateController.text.replaceAll(',', '.'));
      if (_isEditing) {
        await _projectRepository.update(
          widget.project!.id,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          imageUrl: imageUrl,
          laborHours: laborHours,
          laborRatePerHour: laborRate,
        );
      } else {
        await _projectRepository.create(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          imageUrl: imageUrl,
          laborHours: laborHours,
          laborRatePerHour: laborRate,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = e is ApiException ? e.message : e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editProject : l10n.addProject)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: _pickedImage != null
                    ? FileImage(_pickedImage!)
                    : (_imageUrl != null ? NetworkImage('$apiBaseUrl$_imageUrl') as ImageProvider : null),
                child: _pickedImage == null && _imageUrl == null ? const Icon(Icons.add_a_photo, size: 32) : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(controller: _nameController, decoration: InputDecoration(labelText: l10n.projectName)),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: l10n.projectDescription),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextField(
                controller: _laborHoursController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.laborHours),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _laborRateController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.laborRatePerHour),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          if (_error != null) Padding(
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
