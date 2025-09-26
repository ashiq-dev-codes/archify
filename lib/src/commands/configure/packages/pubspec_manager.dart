import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void addPackagesToPubspec(Map<String, String> packages) {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ pubspec.yaml not found!');
    return;
  }

  final content = pubspecFile.readAsStringSync();
  final doc = loadYaml(content);
  final editor = YamlEditor(content);

  final dependencies = doc['dependencies'] ?? {};

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
