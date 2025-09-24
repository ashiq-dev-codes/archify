import 'dart:io';

import 'package:yaml/yaml.dart';

/// Reads the package name from pubspec.yaml dynamically
String getPackageName() {
  final file = File('pubspec.yaml');
  if (!file.existsSync()) return 'your_app';
  final content = file.readAsStringSync();
  final doc = loadYaml(content);
  return doc['name'] ?? 'your_app';
}

/// Creates a folder if it doesn't exist. Optional callback after creation.
void createFolder(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
    print('📂 Created $path');
  } else {
    print('✅ $path already exists, skipping.');
  }
}

/// Creates a file if it doesn't exist, or updates it if content is different
void createFile(String path, String content) {
  final file = File(path);
  if (!file.existsSync()) {
    file.writeAsStringSync(content);
    print('📄 Created $path');
  } else {
    final existing = file.readAsStringSync();
    if (existing != content) {
      file.writeAsStringSync(content);
      print('♻️ Updated $path');
    } else {
      print('✅ $path already up-to-date');
    }
  }
}
