import 'dart:io';

import 'package:archify/src/commands/configure/folders/folders.dart';
import 'package:archify/src/commands/configure/packages/packages.dart';
import 'package:archify/src/commands/configure/readme/readme.dart';

/// Configures a Flutter project by creating folders, updating README,
/// adding default packages, and optionally backing up existing code.
class ConfigureCommand {
  /// Runs the configure command.
  ///
  /// If [force] is `true`, existing files will be overwritten without confirmation.
  void run({bool force = false}) {
    // Step 0: Check if lib/main.dart exists
    final mainFile = File('lib/main.dart');
    final isFresh = _isFreshProject(mainFile);

    // Step 1: Prompt user if existing project and not forced
    if (!isFresh && !force) {
      final proceed = _askForConfirmation(
        '⚠️ Existing code detected in lib/main.dart.\n'
        'Running "configure" may overwrite your code.\n'
        'Do you want to continue?',
      );

      if (!proceed) {
        print('❌ Configure cancelled by user.');
        return;
      }
    }

    // Step 2: Backup main.dart if it exists
    if (mainFile.existsSync()) {
      _backupFile(mainFile);
    }

    // 3️⃣ Create base folders
    createBaseFolders();

    // 4️⃣ Update README
    updateReadme();

    // 5️⃣ Add default packages
    addDefaultPackages();

    print('✅ Project configured successfully!');
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
}
