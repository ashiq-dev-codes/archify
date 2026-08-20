import 'dart:io';

import 'package:archify/src/commands/configure/config/architecture_builder.dart';
import 'package:archify/src/commands/configure/config/default_config.dart';
import 'package:archify/src/commands/configure/config/recommended_packages.dart';
import 'package:archify/src/commands/configure/config/templates.dart';
import 'package:archify/src/commands/configure/readme/readme.dart';
import 'package:archify/src/utils/fs_utils.dart';

/// Thrown internally when the user declines to overwrite existing code.
class _ConfigureCancelled implements Exception {}

/// Configures a Flutter project from `archify.yaml`.
///
/// The first run (no `archify.yaml` present) only writes the default config
/// file. Every run after that reads `archify.yaml` and scaffolds the
/// folders/files it describes. Archify never edits `pubspec.yaml`.
class ConfigureCommand {
  /// Runs the configure command.
  ///
  /// If [force] is `true`, the existing-code confirmation prompt is skipped.
  void run({bool force = false}) {
    final configFile = File('archify.yaml');

    if (!configFile.existsSync()) {
      configFile.writeAsStringSync(defaultArchifyConfig);
      print('📄 Created archify.yaml');
      print(
        '   Customize it, then run `dart run archify configure` again to scaffold your project.',
      );
      return;
    }

    try {
      _guardMainDartOverwrite(force: force);
    } on _ConfigureCancelled {
      print('❌ Configure cancelled by user.');
      return;
    }

    try {
      buildArchitectureFromConfig(configFile);
    } catch (e) {
      print('❌ Failed to apply archify.yaml: $e');
      return;
    }

    updateReadme();
    _printPackageReminder();

    print('✅ Project configured successfully!');
  }

  /// Prompts and backs up `lib/main.dart` only when applying `archify.yaml`
  /// would actually change it and it doesn't look like a fresh project.
  void _guardMainDartOverwrite({required bool force}) {
    final mainFile = File('lib/main.dart');
    if (!mainFile.existsSync()) return;

    final intended = renderBaseTemplate('main', getPackageName());
    if (intended == null) return;

    if (mainFile.readAsStringSync() == intended) return;

    final isFresh = _isFreshProject(mainFile);
    if (!isFresh && !force) {
      final proceed = _askForConfirmation(
        '⚠️ Existing code detected in lib/main.dart.\n'
        'Running "configure" may overwrite your code.\n'
        'Do you want to continue?',
      );

      if (!proceed) throw _ConfigureCancelled();
    }

    _backupFile(mainFile);
  }

  /// Checks if the project is fresh (default Flutter template)
  bool _isFreshProject(File mainFile) {
    if (!mainFile.existsSync()) return true;

    final content = mainFile.readAsStringSync();
    // crude detection of default counter app
    return content.contains('MyHomePage') && content.contains('Counter');
  }

  /// Prompts user for confirmation
  bool _askForConfirmation(String message) {
    stdout.write('$message [y/N]: ');
    final input = stdin.readLineSync()?.trim().toLowerCase();
    return input == 'y';
  }

  /// Creates a backup of a file
  void _backupFile(File file) {
    final backupPath = '${file.path}.bak';
    file.copySync(backupPath);
    print('📦 Backup created: $backupPath');
  }

  /// Reminds the developer to add the packages the default templates expect.
  void _printPackageReminder() {
    print(
      '📦 Archify never edits pubspec.yaml — add these packages yourself if you use the default templates:',
    );
    print('   flutter pub add ${recommendedPackages.join(' ')}');
  }
}
