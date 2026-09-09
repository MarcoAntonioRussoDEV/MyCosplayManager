import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/api_client.dart';
import '../core/models/project.dart';
import '../l10n/app_localizations.dart';
import 'edit_project_page.dart';
import 'project_detail_page.dart';
import 'project_repository.dart';

class ProjectsListPage extends StatefulWidget {
  const ProjectsListPage({super.key});

  @override
  State<ProjectsListPage> createState() => _ProjectsListPageState();
}

class _ProjectsListPageState extends State<ProjectsListPage> {
  late final ProjectRepository _repository;
  late Future<List<Project>> _future;

  @override
  void initState() {
    super.initState();
    _repository = ProjectRepository(context.read<AuthService>().apiClient);
    _future = _repository.list();
  }

  void _reload() {
    setState(() {
      _future = _repository.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProjects)),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: FutureBuilder<List<Project>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              final message =
                  snapshot.error is ApiException ? (snapshot.error as ApiException).message : l10n.errorGeneric;
              return Center(child: Text(message));
            }
            final projects = snapshot.data ?? [];
            if (projects.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: Center(child: Text(l10n.projectsEmpty, textAlign: TextAlign.center)),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: project.imageUrl != null
                        ? NetworkImage('$apiBaseUrl${project.imageUrl}')
                        : null,
                    child: project.imageUrl == null ? const Icon(Icons.checkroom) : null,
                  ),
                  title: Text(project.name),
                  subtitle: project.description != null ? Text(project.description!, maxLines: 1, overflow: TextOverflow.ellipsis) : null,
                  onTap: () async {
                    final changed = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(builder: (_) => ProjectDetailPage(projectId: project.id)),
                    );
                    if (changed == true) _reload();
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const EditProjectPage()),
          );
          if (created == true) _reload();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
