import 'dart:io';

/// The fresh `lib/main.dart` written after a reset — a single screen with
/// centered text, nothing else.
const _freshMainDart = '''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Edit lib/main.dart to get started'),
        ),
      ),
    );
  }
}
''';

/// Resets `lib/` back to a blank starter app — mirrors Expo's
/// `npm run reset-project`: optionally move the existing code out of the
/// way first, then write a minimal one-screen `main.dart`.
class ResetProjectCommand {
  /// Runs the reset-project command with the provided [args].
  ///
  /// Supports `--example-dir <name>` to change where existing code is moved
  /// to when kept (defaults to `example`).
  void run(List<String> args) {
    final libDir = Directory('lib');

    if (!libDir.existsSync()) {
      _writeFreshMain();
      print('✅ No existing lib/ found — created a fresh lib/main.dart.');
      return;
    }

    final exampleDirName = _readExampleDirName(args);

    final keep = _askForConfirmation(
      '📦 Keep your current code? It will be moved to "$exampleDirName/" instead of deleted. [Y/n]: ',
    );

    if (keep) {
      final exampleDir = Directory(exampleDirName);
      if (exampleDir.existsSync()) {
        print(
          '❌ "$exampleDirName/" already exists. Remove or rename it, or pass a different name with --example-dir, then try again.',
        );
        return;
      }

      libDir.renameSync(exampleDirName);
      print(
        '📦 Existing code moved to "$exampleDirName/". It\'s not wired into your app anymore — reference it or delete it whenever you\'re ready.',
      );
    } else {
      libDir.deleteSync(recursive: true);
      print('🗑️ Removed the existing lib/ directory.');
    }

    _writeFreshMain();
    print('✨ lib/main.dart reset to a fresh starter screen.');
    print('✅ Project reset complete!');
  }

  String _readExampleDirName(List<String> args) {
    final index = args.indexOf('--example-dir');
    if (index != -1 && index + 1 < args.length) {
      return args[index + 1];
    }
    return 'example';
  }

  void _writeFreshMain() {
    Directory('lib').createSync(recursive: true);
    File('lib/main.dart').writeAsStringSync(_freshMainDart);
  }

  /// Prompts user for confirmation, defaulting to "yes" on empty input.
  bool _askForConfirmation(String message) {
    stdout.write(message);
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    return input != 'n' && input != 'no';
  }
}
