import 'dart:io';

import 'package:archify/src/utils/fs_utils.dart';
import 'package:yaml/yaml.dart';

/// Creates a custom feature based on a type-driven YAML template
void createCustomFeature({
  required String featureName,
  required String templatePath,
}) {
  final file = File(templatePath);
  if (!file.existsSync()) {
    throw Exception('Template file not found: $templatePath');
  }

  YamlMap yamlMap;
  try {
    yamlMap = loadYaml(file.readAsStringSync());
  } catch (e) {
    throw Exception('❌ Failed to parse YAML: $e');
  }

  final featureMap = yamlMap['feature'];
  if (featureMap == null || featureMap is! Map) {
    throw Exception('❌ Invalid YAML: "feature" key missing or invalid');
  }

  featureMap.forEach((key, children) {
    if (children == null || children is! List) {
      throw Exception('❌ Invalid YAML: children must be a list under "$key"');
    }

    // Replace placeholders in folder name
    final featureKey = key.replaceAll("{feature_name}", featureName);

    try {
      _processItems("lib/$featureKey", children, featureName: featureName);
    } catch (e) {
      throw Exception('❌ Failed to generate feature "$featureName": $e');
    }
  });
}

/// Recursive function to create folders and files based on explicit type
void _processItems(
  String basePath,
  dynamic items, {
  required String featureName,
}) {
  if (items is! List) {
    throw Exception('Expected a list of items under "$basePath"');
  }

  for (var item in items) {
    if (item is! Map ||
        !item.containsKey('name') ||
        !item.containsKey('type')) {
      throw Exception(
        'Each item must be a map with "name" and "type" under "$basePath"',
      );
    }

    // Replace placeholders in name
    var name = item['name'].toString();

    // Warn if placeholder may cause YAML issues
    if (name.contains("{feature_name}") &&
        !name.startsWith('"') &&
        !name.startsWith("'")) {
      print(
        '⚠️ Warning: "{feature_name}" placeholder in "$name" should be quoted in YAML.',
      );
    }

    name = name.replaceAll("{feature_name}", featureName);
    final type = item['type'].toString();

    if (type != 'folder' && type != 'file') {
      throw Exception(
        'Invalid type "$type" for "$name". Must be "folder" or "file".',
      );
    }

    if (type == 'folder') {
      final folderPath = '$basePath/$name';
      createFolder(folderPath);

      if (item.containsKey('children')) {
        final children = item['children'];
        if (children == null || children is! List) {
          throw Exception('Children of folder "$name" must be a list');
        }
        _processItems(folderPath, children, featureName: featureName);
      }
    } else if (type == 'file') {
      final filePath = '$basePath/$name';
      createFile(filePath, '');
    }
  }
}
