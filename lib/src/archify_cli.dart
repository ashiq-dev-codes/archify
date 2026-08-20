import 'package:archify/src/commands/configure/configure.dart';
import 'package:archify/src/commands/custom/custom.dart';
import 'package:archify/src/commands/generate/generate.dart';
import 'package:archify/src/commands/init/init.dart';
import 'package:archify/src/commands/reset/reset.dart';
import 'package:archify/src/commands/templates/templates.dart';
import 'package:archify/src/utils/version_utils.dart';

/// The main entry point for the Archify command-line interface (CLI).
///
/// This class handles parsing of command-line arguments and executes
/// the appropriate commands such as `init`, `configure`, `generate`,
/// `custom`, `templates`, `reset-project`, or `version`.
class ArchifyCLI {
  /// Runs the Archify CLI with the provided [args].
  ///
  /// Supported commands:
  /// - `init`: Creates `archify.yaml` describing the project architecture.
  /// - `configure`: Scaffolds the project from `archify.yaml`.
  /// - `generate`: Runs the default feature generation command.
  /// - `custom`: Runs the custom feature generation command using a template.
  /// - `templates`: Lists every built-in `template:` key.
  /// - `reset-project`: Resets lib/ back to a blank starter app.
  /// - `version`: Prints the current version of the CLI.
  ///
  /// Example:
  /// ```dart
  /// final cli = ArchifyCLI();
  /// cli.run(['custom', 'booking', '--template', 'path/to/template.yaml']);
  /// ```
  void run(List<String> args) {
    if (args.isEmpty) {
      _printUsage();
      return;
    }

    final command = args.first;
    final commandArgs = args.sublist(1); // rest of arguments

    switch (command) {
      case 'init':

        /// Creates archify.yaml
        InitCommand().run();
        break;

      case 'configure':

        /// Scaffolds the project from archify.yaml
        ConfigureCommand().run();
        break;

      case 'generate':

        /// Executes the default feature generation command
        GenerateCommand().run(commandArgs);
        break;

      case 'custom':

        /// Executes the custom feature generation command
        CustomCommand().run(commandArgs);
        break;

      case 'templates':

        /// Lists every built-in template key
        TemplatesCommand().run();
        break;

      case 'reset-project':

        /// Resets lib/ back to a blank starter app
        ResetProjectCommand().run(commandArgs);
        break;

      case 'version':

        /// Prints the current version of Archify CLI
        print('Archify CLI version: ${getCliVersion()}');
        break;

      default:
        print('❌ Unknown command: $command');
        _printUsage();
    }
  }

  /// Prints CLI usage instructions
  void _printUsage() {
    print(
      'Usage: archify <init|configure|generate|custom|templates|reset-project|version> [options]',
    );
    print('\nCommands:');
    print(
      '  init                    Create archify.yaml describing your project architecture',
    );
    print(
      '  configure               Scaffold the project from archify.yaml (creates it first if missing)',
    );
    print(
      '  generate <feature>      Generate a new feature/module (default architecture)',
    );
    print(
      '  custom <feature>        Generate a feature using a custom template',
    );
    print(
      '  templates               List every built-in template key archify.yaml can use',
    );
    print(
      '  reset-project           Reset lib/ to a blank starter app (optionally keeping old code in example/)',
    );
    print('  version                 Show current Archify CLI version');
    print('\nExample:');
    print(
      '  archify custom booking --template path/to/custom_template.yaml --overwrite',
    );
    print('  archify reset-project --example-dir old_app');
  }
}
