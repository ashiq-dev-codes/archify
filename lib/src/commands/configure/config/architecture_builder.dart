import 'dart:io';

import 'package:archify/src/commands/configure/config/templates.dart';
import 'package:archify/src/utils/fs_utils.dart';
import 'package:archify/src/utils/yaml_tree.dart';
import 'package:yaml/yaml.dart';

/// Reads `archify.yaml` and scaffolds the folders/files described under its
/// `structure` key.
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

  walkYamlTree(
    '',
    doc['structure'],
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
}
