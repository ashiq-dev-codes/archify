import 'dart:io';

import 'package:archify/src/commands/configure/config/templates.dart';
import 'package:archify/src/utils/fs_utils.dart';
import 'package:archify/src/utils/manifest.dart';
import 'package:archify/src/utils/reconcile.dart';
import 'package:archify/src/utils/yaml_tree.dart';
import 'package:yaml/yaml.dart';

/// Reads `archify.yaml` and scaffolds the folders/files described under its
/// `structure` key.
///
/// A path `configure` created on a previous run that's no longer declared
/// under `structure` is backed up to `.archify/removed/` rather than left
/// behind stale — see `reconcileRemovedPaths`.
///
/// Throws an [Exception] with a descriptive message on malformed YAML.
void buildArchitectureFromConfig(File configFile) {
  final dynamic doc;
  try {
    doc = loadYaml(configFile.readAsStringSync());
  } catch (e) {
    throw Exception('Failed to parse YAML: $e');
  }

  if (doc is! Map || doc['structure'] is! Map) {
    throw Exception('"structure" key missing or invalid in archify.yaml');
  }

  final packageName = getPackageName();
  final structureNode = doc['structure'] as Map;
  final desiredPaths = collectYamlTreePaths('', structureNode);

  final manifest = ArchifyManifest.load();
  reconcileRemovedPaths(
    previousPaths: manifest.structure,
    currentPaths: desiredPaths,
  );

  walkYamlTree(
    '',
    structureNode,
    resolveFileContent: (path, templateKey) {
      final rendered = renderBaseTemplate(templateKey, packageName);
      if (rendered == null) {
        print(
          '⚠️ Unknown template "$templateKey" for "$path", creating empty file.',
        );
      }
      return rendered;
    },
  );

  manifest.structure
    ..clear()
    ..addAll(desiredPaths);
  manifest.save();
}
