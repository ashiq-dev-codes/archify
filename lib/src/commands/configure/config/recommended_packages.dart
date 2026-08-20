/// Packages the default Archify templates (`structure` and
/// `feature_template` alike) assume are available.
///
/// Archify never edits `pubspec.yaml` — the developer adds whichever of
/// these they actually use via `flutter pub add`. `dio` and `get_it` aren't
/// listed here since the default architecture no longer includes the
/// networking/DI templates that need them — add them yourself if you opt
/// back into `dio_client`/`injection_container`/`feature_injection`.
const recommendedPackages = [
  'corextra',
  'equatable',
  'flutter_bloc',
  'device_preview',
  'shared_preferences',
];
