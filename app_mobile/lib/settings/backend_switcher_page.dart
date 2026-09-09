import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';

/// Sceglie a runtime il backend a cui punta l'app (solo build di test, vedi
/// enableTestBackendSwitcher in core/env.dart): locale via adb reverse, LAN,
/// oppure un URL custom. Il cambio forza il re-login.
class BackendSwitcherPage extends StatefulWidget {
  const BackendSwitcherPage({super.key});

  @override
  State<BackendSwitcherPage> createState() => _BackendSwitcherPageState();
}

class _BackendSwitcherPageState extends State<BackendSwitcherPage> {
  static const _presets = <({String label, String url, String? note})>[
    (
      label: 'Locale (adb reverse)',
      url: 'http://localhost:8080',
      note: 'adb reverse tcp:8080 tcp:8080, dispositivo USB',
    ),
  ];
  static const _customValue = '__custom__';

  final _customController = TextEditingController();

  late String _selected;
  bool _custom = false;
  bool _saving = false;
  String? _customError;

  @override
  void initState() {
    super.initState();
    _selected = context.read<AuthService>().baseUrl;
    final presetUrls = _presets.map((p) => p.url).toSet();
    if (!presetUrls.contains(_selected)) {
      _custom = true;
      _customController.text = _selected;
    }
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String? _validateCustom(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Inserisci un URL';
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
      return 'Deve iniziare con http:// o https://';
    }
    return null;
  }

  Future<void> _save() async {
    final url = _custom ? _customController.text.trim() : _selected;
    if (_custom) {
      final error = _validateCustom(url);
      if (error != null) {
        setState(() => _customError = error);
        return;
      }
    }
    setState(() => _saving = true);
    try {
      await context.read<AuthService>().setBackendUrl(url);
      // setBackendUrl fa signOut(): app.dart torna da solo alla LoginPage.
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Errore: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Backend (dev)')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Scegli il server a cui punta l\'app. Il cambio forza il re-login.'),
          const SizedBox(height: 16),
          RadioGroup<String>(
            groupValue: _custom ? _customValue : _selected,
            onChanged: (value) {
              if (_saving) return;
              setState(() {
                if (value == _customValue) {
                  _custom = true;
                } else {
                  _selected = value!;
                  _custom = false;
                }
                _customError = null;
              });
            },
            child: Column(
              children: [
                for (final preset in _presets)
                  RadioListTile<String>(
                    value: preset.url,
                    title: Text(preset.label),
                    subtitle: preset.note != null ? Text(preset.note!) : null,
                  ),
                RadioListTile<String>(value: _customValue, title: const Text('Custom')),
                if (_custom)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: TextField(
                      controller: _customController,
                      autofocus: true,
                      keyboardType: TextInputType.url,
                      decoration: InputDecoration(
                        labelText: 'URL backend',
                        hintText: 'http://192.168.1.10:8080',
                        errorText: _customError,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Salva e accedi'),
          ),
        ],
      ),
    );
  }
}
