import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// Cleans the pubspec.yaml file by removing boilerplate comments
/// but keeping important template sections like assets/fonts.
void cleanPubspec() {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found!');
    return;
  }

  final content = pubspecFile.readAsLinesSync();

  // Keywords for comment blocks we want to preserve
  final keepBlocks = ['# assets:', '# fonts:'];

  final cleaned = <String>[];
  bool inKeepBlock = false;

  for (final line in content) {
    final trimmed = line.trimLeft();

    if (keepBlocks.any((k) => trimmed.startsWith(k))) {
      // Start of a keep-block
      inKeepBlock = true;
      cleaned.add(line);
      continue;
    }

    if (inKeepBlock) {
      if (trimmed.startsWith('#') || trimmed.isEmpty) {
        // Still inside keep-block (indented comment lines / blank lines)
        cleaned.add(line);
        continue;
      } else {
        // End of keep-block when a non-comment appears
        inKeepBlock = false;
      }
    }

    // Remove all other standalone comments
    if (trimmed.startsWith('#')) {
      continue;
    }

    cleaned.add(line);
  }

  final result = cleaned.join('\n').replaceAll(RegExp(r'\n{2,}'), '\n\n');

  pubspecFile.writeAsStringSync('${result.trim()}\n');
  print('🧹 pubspec.yaml cleaned (kept asset/font templates)!');
}

/// Adds packages to the dependencies section of pubspec.yaml.
/// Cleans the file before applying updates.
void addPackagesToPubspec(Map<String, String> packages) {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found!');
    return;
  }

  // Step 1: Clean before editing
  cleanPubspec();

  // Step 2: Load and update YAML
  final content = pubspecFile.readAsStringSync();
  final doc = loadYaml(content);
  final editor = YamlEditor(content);

  final dependencies = Map<String, dynamic>.from(doc['dependencies'] ?? {});

  packages.forEach((pkg, version) {
    if (!dependencies.containsKey(pkg)) {
      print('➕ Adding package: $pkg');
      editor.update(['dependencies', pkg], version);
    } else {
      print('✅ Package $pkg already exists, skipping.');
    }
  });

  pubspecFile.writeAsStringSync(editor.toString());
  print('✅ pubspec.yaml updated!');
}
