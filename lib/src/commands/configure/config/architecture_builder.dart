import 'dart:io';

import 'package:archify/src/commands/configure/config/templates.dart';
import 'package:archify/src/utils/fs_utils.dart';
import 'package:yaml/yaml.dart';

/// Reads `archify.yaml` and scaffolds the folders/files it describes.
///
/// Throws an [Exception] with a descriptive message on malformed YAML.
void buildArchitectureFromConfig(File configFile) {
  final dynamic doc;
  try {
    doc = loadYaml(configFile.readAsStringSync());
  } catch (e) {
    throw Exception('Failed to parse YAML: $e');
  }

  if (doc is! Map || doc['structure'] is! List) {
    throw Exception('"structure" key missing or invalid in archify.yaml');
  }

  final packageName = getPackageName();
  _processNodes('', doc['structure'], packageName);
}

/// Recursively walks `archify.yaml` nodes, creating folders and files.
void _processNodes(String basePath, dynamic items, String packageName) {
  if (items is! List) {
    throw Exception('Expected a list of nodes under "$basePath"');
  }

  for (final item in items) {
    if (item is! Map ||
        !item.containsKey('name') ||
        !item.containsKey('type')) {
      throw Exception(
        'Each node must be a map with "name" and "type" under "$basePath"',
      );
    }

    final name = item['name'].toString();
    final type = item['type'].toString();
    final path = basePath.isEmpty ? name : '$basePath/$name';

    if (type == 'folder') {
      createFolder(path);

      final children = item['children'];
      if (children != null) {
        if (children is! List) {
          throw Exception('"children" of "$name" must be a list');
        }
        _processNodes(path, children, packageName);
      }
    } else if (type == 'file') {
      final templateKey = item['template']?.toString();
      var content = '';
      if (templateKey != null) {
        final rendered = renderBaseTemplate(templateKey, packageName);
        if (rendered == null) {
          print(
            '⚠️ Unknown template "$templateKey" for "$name", creating empty file.',
          );
        } else {
          content = rendered;
        }
      }
      createFile(path, content);
    } else {
      throw Exception(
        'Invalid type "$type" for "$name". Must be "folder" or "file".',
      );
    }
  }
}
