import 'package:archify/src/commands/configure/configure.dart';
import 'package:archify/src/commands/generate/generate.dart';
import 'package:archify/src/utils/version_utils.dart';

/// The main entry point for the Archify command-line interface (CLI).
///
/// This class handles parsing of command-line arguments and executes
/// the appropriate commands such as `configure`, `generate`, or `version`.
class ArchifyCLI {
  /// Runs the Archify CLI with the provided [args].
  ///
  /// Supported commands:
  /// - `configure`: Runs the configuration command.
  /// - `generate`: Runs the generation command with optional arguments.
  /// - `version`: Prints the current version of the CLI.
  ///
  /// If [args] is empty or an unknown command is provided, usage instructions
  /// will be printed to the console.
  ///
  /// Example:
  /// ```dart
  /// final cli = ArchifyCLI();
  /// cli.run(['generate', '--output', 'lib']);
  /// ```
  void run(List<String> args) {
    if (args.isEmpty) {
      print('Usage: archify <configure|generate|version> [options]');
      return;
    }

    final command = args.first;
    final commandArgs = args.sublist(1); // rest of arguments

    switch (command) {
      case 'configure':

        /// Executes the configure command.
        ConfigureCommand().run();
        break;
      case 'generate':

        /// Executes the generate command with provided arguments.
        GenerateCommand().run(commandArgs);
        break;
      case 'version':

        /// Prints the current version of Archify CLI.
        print('Archify CLI version: ${getCliVersion()}');
        break;
      default:
        print('❌ Unknown command: $command');
        print('Usage: archify <configure|generate|version> [options]');
    }
  }
}
