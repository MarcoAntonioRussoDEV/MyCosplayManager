import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/env.dart';
import '../l10n/app_localizations.dart';
import '../settings/backend_switcher_page.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  String? _error;

  Future<void> _signIn() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await context.read<AuthService>().signInWithGoogle();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.checkroom, size: 96, color: Colors.deepPurple),
                const SizedBox(height: 24),
                Text(l10n.appTitle, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(l10n.loginSubtitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 40),
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                ],
                FilledButton.icon(
                  onPressed: _loading ? null : _signIn,
                  icon: _loading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.login),
                  label: Text(l10n.loginWithGoogle),
                ),
                if (enableTestBackendSwitcher)
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const BackendSwitcherPage()),
                    ),
                    child: Text('Backend: ${context.watch<AuthService>().baseUrl}'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
