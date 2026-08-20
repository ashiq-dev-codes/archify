import 'dart:io';

import 'package:archify/src/commands/configure/config/default_config.dart';

/// Creates `archify.yaml` — the single source of truth for
/// `dart run archify configure` and `dart run archify generate`.
///
/// This command never touches the filesystem beyond `archify.yaml` itself.
/// Use `dart run archify configure` to actually scaffold the project from it.
class InitCommand {
  /// Runs the init command.
  void run() {
    final configFile = File('archify.yaml');

    if (configFile.existsSync()) {
      print('ℹ️ archify.yaml already exists.');
      print(
        '   Edit it, then run `dart run archify configure` to scaffold your project.',
      );
      return;
    }

    configFile.writeAsStringSync(defaultArchifyConfig);
    print('📄 Created archify.yaml');
    print(
      '   Customize it, then run `dart run archify configure` to scaffold your project.',
    );
  }
}
