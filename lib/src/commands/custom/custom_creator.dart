import 'dart:io';

import 'package:archify/src/utils/fs_utils.dart';
import 'package:yaml/yaml.dart';

/// Creates a custom feature based on a YAML template
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
    _createFoldersAndFiles("lib/$featureKey", children, featureName);
  });
}

/// Recursive folder/file creation using fs_utils
void _createFoldersAndFiles(
  String basePath,
  dynamic items,
  String featureName,
) {
  if (items is List) {
    for (var item in items) {
      if (item is String) {
        final folderPath = "$basePath/$item";
        createFolder(folderPath);

        // Automatically create default files
        _createDefaultFile(folderPath, item, featureName);
      } else if (item is Map) {
        item.forEach((parent, children) {
          final folderPath = "$basePath/$parent";
          createFolder(folderPath);
          _createFoldersAndFiles(folderPath, children, featureName);
        });
      }
    }
  }
}

/// Creates default files based on folder type using fs_utils
void _createDefaultFile(
  String folderPath,
  String folderName,
  String featureName,
) {
  String? fileName;

  if (folderName.toLowerCase() == 'screens') {
    fileName = '${featureName}_page.dart';
  } else if (folderName.toLowerCase() == 'models') {
    fileName = '${featureName}_model.dart';
  } else if (folderName.toLowerCase() == 'services') {
    fileName = '${featureName}_service.dart';
  } else if (folderName.toLowerCase() == 'api' ||
      folderName.toLowerCase() == 'view') {
    fileName = '${featureName}_${folderName.toLowerCase()}.dart';
  }

  if (fileName != null) {
    final filePath = '$folderPath/$fileName';
    createFile(filePath, ''); // create empty file
  }
}
