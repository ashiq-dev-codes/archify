import 'package:archify/src/commands/configure/configure.dart';
import 'package:archify/src/commands/custom/custom.dart';
import 'package:archify/src/commands/generate/generate.dart';
import 'package:archify/src/utils/version_utils.dart';

/// The main entry point for the Archify command-line interface (CLI).
///
/// This class handles parsing of command-line arguments and executes
/// the appropriate commands such as `configure`, `generate`, `custom`, or `version`.
class ArchifyCLI {
  /// Runs the Archify CLI with the provided [args].
  ///
  /// Supported commands:
  /// - `configure`: Runs the configuration command.
  /// - `generate`: Runs the default feature generation command.
  /// - `custom`: Runs the custom feature generation command using a template.
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
      case 'configure':

        /// Executes the configure command
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
    print('Usage: archify <configure|generate|custom|version> [options]');
    print('\nCommands:');
    print('  configure               Set up base project structure');
    print(
      '  generate <feature>      Generate a new feature/module (default architecture)',
    );
    print(
      '  custom <feature>        Generate a feature using a custom template',
    );
    print('  version                 Show current Archify CLI version');
    print('\nExample:');
    print(
      '  archify custom booking --template path/to/custom_template.yaml --overwrite',
    );
  }
}
