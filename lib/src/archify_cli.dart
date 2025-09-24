import 'package:archify/src/commands/configure/configure.dart';
import 'package:archify/src/commands/generate/generate.dart';
import 'package:archify/src/utils/version_utils.dart';

class ArchifyCLI {
  void run(List<String> args) {
    if (args.isEmpty) {
      print('Usage: archify <configure|generate|version> [options]');
      return;
    }

    final command = args.first;
    final commandArgs = args.sublist(1); // rest of arguments

    switch (command) {
      case 'configure':
        ConfigureCommand().run();
        break;
      case 'generate':
        GenerateCommand().run(commandArgs);
        break;
      case 'version':
        print('Archify CLI version: ${getCliVersion()}');
        break;
      default:
        print('❌ Unknown command: $command');
        print('Usage: archify <configure|generate|version> [options]');
    }
  }
}
