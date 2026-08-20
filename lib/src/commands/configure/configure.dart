import 'dart:io';

import 'package:archify/src/commands/configure/config/architecture_builder.dart';
import 'package:archify/src/commands/configure/config/recommended_packages.dart';
import 'package:archify/src/commands/configure/config/templates.dart';
import 'package:archify/src/commands/configure/readme/readme.dart';
import 'package:archify/src/commands/init/init.dart';
import 'package:archify/src/utils/fs_utils.dart';

/// Thrown internally when the user declines to overwrite existing code.
class _ConfigureCancelled implements Exception {}

/// Scaffolds the project from `archify.yaml`'s `structure` section.
///
/// If `archify.yaml` doesn't exist yet, prompts to run `init` first (which
/// creates it) before continuing with configure. Archify never edits
/// `pubspec.yaml`.
class ConfigureCommand {
  /// Runs the configure command.
  ///
  /// If [force] is `true`, the existing-code confirmation prompt is skipped.
  void run({bool force = false}) {
    final configFile = File('archify.yaml');

    if (!configFile.existsSync()) {
      print(
        '❌ No archify.yaml found. Run `dart run archify init` first to create it.',
      );

      final proceed = _askYesNoDefaultYes('Run init now? [Y/n]: ');
      if (!proceed) {
        print('❌ Configure cancelled.');
        return;
      }

      InitCommand().run();

      if (!configFile.existsSync()) {
        print('❌ archify.yaml still not found after running init.');
        return;
      }
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
      final proceed = _askOverwriteConfirmation(
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

  /// Prompts for confirmation before overwriting existing code, defaulting
  /// to "no" on empty input — this one is destructive, so it stays opt-in.
  bool _askOverwriteConfirmation(String message) {
    stdout.write('$message [y/N]: ');
    final input = stdin.readLineSync()?.trim().toLowerCase();
    return input == 'y';
  }

  /// Prompts for confirmation, defaulting to "yes" on empty input — used for
  /// low-risk, easily-reversible steps like running `init`.
  bool _askYesNoDefaultYes(String message) {
    stdout.write(message);
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    return input != 'n' && input != 'no';
  }

  /// Creates a backup of a file
  void _backupFile(File file) {
    final backupPath = '${file.path}.bak';
    file.copySync(backupPath);
    print('📦 Backup created: $backupPath');
  }

  /// Reminds the developer that the default templates need no packages, and
  /// what to add if they opt into the Cubit/Bloc pattern later.
  void _printPackageReminder() {
    print(
      '📦 Archify never edits pubspec.yaml. The default templates need nothing beyond the Flutter SDK.',
    );
    print(
      '   Opting into the Cubit/Bloc templates (cubit, cubit_state, feature_injection)? Run:',
    );
    print('   flutter pub add ${recommendedPackages.join(' ')}');
  }
}
