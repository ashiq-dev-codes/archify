/// Packages needed by the opt-in Cubit/Bloc templates (`cubit`, `cubit_state`,
/// `feature_injection`) — neither the default `structure` (used by
/// `configure`) nor the default `feature_template` (used by `generate`)
/// scaffolds anything that needs a package beyond the Flutter SDK.
///
/// Archify never edits `pubspec.yaml` — the developer adds whichever of
/// these they actually use via `flutter pub add`. `dio`, `get_it`,
/// `corextra`, `device_preview`, and `shared_preferences` aren't listed here
/// either — add them yourself if you opt into `dio_client`/
/// `injection_container`/`feature_injection`, or reintroduce logging/
/// device-preview/local-storage in `main.dart`/`app.dart`/`root.dart`.
const recommendedPackages = ['equatable', 'flutter_bloc'];
