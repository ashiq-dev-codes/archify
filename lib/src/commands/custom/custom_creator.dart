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

  final yamlMap = loadYaml(file.readAsStringSync());
  final featureMap = yamlMap['feature'] ?? {};

  featureMap.forEach((key, children) {
    final featureKey = key.replaceAll("{feature_name}", featureName);
    _processItems("lib/$featureKey", children);
  });
}

/// Recursive function to create folders and files based on explicit type
void _processItems(String basePath, dynamic items) {
  if (items is List) {
    for (var item in items) {
      if (item is Map) {
        final name = item['name'] as String;
        final type = item['type'] as String;

        if (type == 'folder') {
          final folderPath = '$basePath/$name';
          createFolder(folderPath);

          if (item.containsKey('children')) {
            _processItems(folderPath, item['children']);
          }
        } else if (type == 'file') {
          final filePath = '$basePath/$name';
          createFile(filePath, '');
        }
      }
    }
  }
}
