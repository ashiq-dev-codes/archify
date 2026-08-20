/// Packages the default `feature_template` (used by `generate`) assumes are
/// available. The `structure` default (used by `configure`) needs nothing
/// beyond the Flutter SDK — `flutter_bloc` and `equatable` are only pulled
/// in once you generate a feature's Cubit/state files.
///
/// Archify never edits `pubspec.yaml` — the developer adds whichever of
/// these they actually use via `flutter pub add`. `dio`, `get_it`,
/// `corextra`, `device_preview`, and `shared_preferences` aren't listed here
/// since none of the default templates need them anymore — add them
/// yourself if you opt back into `dio_client`/`injection_container`/
/// `feature_injection`, or reintroduce logging/device-preview/local-storage
/// in `main.dart`/`app.dart`/`root.dart`.
const recommendedPackages = ['equatable', 'flutter_bloc'];
