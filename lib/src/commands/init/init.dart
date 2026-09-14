import 'dart:io';

import 'package:archify/src/commands/init/config/architectures.dart';

/// Creates `archify.yaml` — the single source of truth for
/// `dart run archify configure` and `dart run archify generate`.
///
/// This command never touches the filesystem beyond `archify.yaml` itself.
/// Use `dart run archify configure` to actually scaffold the project from it.
class InitCommand {
  /// Runs the init command.
  ///
  /// Pass `--arch <key>` in [args] to pick an architecture non-interactively
  /// (see `architecturePresets` for the available keys); otherwise prompts
  /// for one, defaulting to [defaultArchitectureKey] on a blank/EOF answer.
  void run(List<String> args) {
    final configFile = File('archify.yaml');

    if (configFile.existsSync()) {
      print('ℹ️ archify.yaml already exists.');
      print(
        '   Edit it, then run `dart run archify configure` to scaffold your project.',
      );
      return;
    }

    final architecture = _resolveArchitecture(args);
    if (architecture == null) return;

    configFile.writeAsStringSync(architecture.archifyYaml);
    print('📄 Created archify.yaml (${architecture.label})');
    print(
      '   Customize it, then run `dart run archify configure` to scaffold your project.',
    );
  }

  /// Reads `--arch <key>` from [args] if present, otherwise prompts
  /// interactively. Returns `null` (having already printed why) if `--arch`
  /// was given an unrecognized value.
  ArchitecturePreset? _resolveArchitecture(List<String> args) {
    final flagIndex = args.indexOf('--arch');
    if (flagIndex == -1) return _promptForArchitecture();

    if (flagIndex + 1 >= args.length) {
      print('❌ --arch requires a value.');
      _printAvailableArchitectures();
      return null;
    }

    final key = args[flagIndex + 1].toLowerCase();
    final preset = architecturePresets[key];
    if (preset == null) {
      print('❌ Unknown architecture "$key".');
      _printAvailableArchitectures();
      return null;
    }

    return preset;
  }

  ArchitecturePreset _promptForArchitecture() {
    final keys = architecturePresets.keys.toList();

    print('📐 Which architecture should archify.yaml start from?');
    for (var i = 0; i < keys.length; i++) {
      final key = keys[i];
      final preset = architecturePresets[key]!;
      final defaultTag = key == defaultArchitectureKey ? ' (default)' : '';
      print('  ${i + 1}) ${preset.label}$defaultTag — ${preset.description}');
    }
    stdout.write(
      'Choose a number or name (default: $defaultArchitectureKey): ',
    );

    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    final fallback = architecturePresets[defaultArchitectureKey]!;
    if (input.isEmpty) return fallback;

    final byNumber = int.tryParse(input);
    if (byNumber != null && byNumber >= 1 && byNumber <= keys.length) {
      return architecturePresets[keys[byNumber - 1]]!;
    }

    final byKey = architecturePresets[input];
    if (byKey != null) return byKey;

    print('⚠️ Unrecognized choice "$input", using ${fallback.label}.');
    return fallback;
  }

  void _printAvailableArchitectures() {
    print('   Available: ${architecturePresets.keys.join(', ')}');
  }
}
