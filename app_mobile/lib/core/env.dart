/// Abilita l'interruttore backend in Impostazioni (solo build di test): permette
/// di cambiare a runtime l'ambiente (locale via adb reverse, LAN, custom) senza
/// ricompilare con API_BASE_URL. Le build prod restano senza interruttore.
///   flutter run --dart-define=ENABLE_TEST_BACKEND_SWITCHER=true
const bool enableTestBackendSwitcher = bool.fromEnvironment(
  'ENABLE_TEST_BACKEND_SWITCHER',
  defaultValue: false,
);
