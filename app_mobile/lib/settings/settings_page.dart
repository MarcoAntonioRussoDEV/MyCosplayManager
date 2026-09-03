import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import '../core/locale_controller.dart';
import '../l10n/app_localizations.dart';
import 'settings_repository.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsRepository _repository;
  Future<void>? _loadFuture;
  UserSettings? _user;
  TeamInfo? _team;

  @override
  void initState() {
    super.initState();
    _repository = SettingsRepository(context.read<AuthService>().apiClient);
    _loadFuture = _load();
  }

  Future<void> _load() async {
    _user = await _repository.getUser();
    _team = await _repository.getTeam();
    if (mounted) setState(() {});
  }

  Future<void> _joinTeamDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.teamInviteCode),
        content: TextField(controller: controller, autofocus: true, textCapitalization: TextCapitalization.characters),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(context).pop(controller.text.trim()), child: Text(l10n.save)),
        ],
      ),
    );
    if (code != null && code.isNotEmpty) {
      try {
        _team = await _repository.joinTeam(code);
        setState(() {});
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeController = context.watch<LocaleController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: FutureBuilder(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (_user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              ListTile(title: Text(_user!.name), subtitle: Text(_user!.email)),
              const Divider(),
              ListTile(
                title: Text(l10n.notificationDaysBefore),
                trailing: DropdownButton<int>(
                  value: _user!.notificationDaysBefore,
                  items: [0, 1, 2, 3, 5, 7, 14, 30]
                      .map((d) => DropdownMenuItem(value: d, child: Text('$d')))
                      .toList(),
                  onChanged: (value) async {
                    if (value == null) return;
                    _user = await _repository.updateNotificationDaysBefore(value);
                    setState(() {});
                  },
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(l10n.language),
                trailing: DropdownButton<Locale?>(
                  value: localeController.override,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Auto')),
                    DropdownMenuItem(value: Locale('it'), child: Text('Italiano')),
                    DropdownMenuItem(value: Locale('en'), child: Text('English')),
                    DropdownMenuItem(value: Locale('es'), child: Text('Espanol')),
                    DropdownMenuItem(value: Locale('fr'), child: Text('Francais')),
                  ],
                  onChanged: (locale) => localeController.setLocale(locale),
                ),
              ),
              const Divider(),
              if (_team != null)
                ListTile(
                  title: Text(_team!.name),
                  subtitle: Text('${l10n.teamInviteCode}: ${_team!.inviteCode}'),
                  trailing: TextButton(onPressed: _joinTeamDialog, child: const Text('Join')),
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(l10n.logout),
                onTap: () => context.read<AuthService>().signOut(),
              ),
            ],
          );
        },
      ),
    );
  }
}
