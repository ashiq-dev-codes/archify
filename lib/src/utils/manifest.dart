import 'dart:convert';
import 'dart:io';

/// Remembers, between runs, exactly which paths `configure`/`generate` last
/// created from `archify.yaml` — so a later run can tell the difference
/// between "removed from the YAML" (safe to reconcile away) and "never
/// managed by Archify" (a file you added by hand, always left alone).
///
/// Stored at [manifestPath]. Commit it alongside `archify.yaml` so removal
/// detection stays consistent across machines and CI.
class ArchifyManifest {
  ArchifyManifest({required this.structure, required this.features});

  static const manifestPath = '.archify/manifest.json';

  /// Every path `configure` created the last time it ran, from `structure`.
  final Set<String> structure;

  /// Every path `generate <name>` created the last time it ran for that
  /// feature, from `feature_template`. Keyed by feature name.
  final Map<String, Set<String>> features;

  /// Loads the manifest, or an empty one if it doesn't exist yet (first run)
  /// or can't be parsed (never crashes `configure`/`generate` over it).
  static ArchifyManifest load() {
    final file = File(manifestPath);
    if (!file.existsSync()) {
      return ArchifyManifest(structure: {}, features: {});
    }

    try {
      final decoded = jsonDecode(file.readAsStringSync());
      if (decoded is! Map) return ArchifyManifest(structure: {}, features: {});

      final structure = _stringSet(decoded['structure']);
      final featuresRaw = decoded['features'];
      final features = <String, Set<String>>{};
      if (featuresRaw is Map) {
        featuresRaw.forEach((key, value) {
          features[key.toString()] = _stringSet(value);
        });
      }

      return ArchifyManifest(structure: structure, features: features);
    } catch (_) {
      return ArchifyManifest(structure: {}, features: {});
    }
  }

  static Set<String> _stringSet(dynamic value) {
    if (value is! List) return {};
    return value.map((e) => e.toString()).toSet();
  }

  void save() {
    final file = File(manifestPath);
    file.parent.createSync(recursive: true);

    final data = {
      'version': 1,
      'structure': structure.toList()..sort(),
      'features': {
        for (final entry in features.entries)
          entry.key: entry.value.toList()..sort(),
      },
    };

    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync('${encoder.convert(data)}\n');
  }
}
