import 'dart:io';

import 'package:yaml/yaml.dart';

String getCliVersion() {
  try {
    final scriptPath = Platform.script.toFilePath();
    final cliDir = Directory(scriptPath).parent.parent; // go up to package root
    final pubspec = File('${cliDir.path}/pubspec.yaml');

    if (!pubspec.existsSync()) return 'unknown';

    final content = pubspec.readAsStringSync();
    final doc = loadYaml(content);
    return doc['version'] ?? 'unknown';
  } catch (_) {
    return 'unknown';
  }
}
