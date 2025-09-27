import 'package:archify/src/commands/generate/data/data_creator.dart';
import 'package:archify/src/commands/generate/domain/domain_creator.dart';
import 'package:archify/src/commands/generate/injection/injection_creator.dart';
import 'package:archify/src/commands/generate/presentation/presentation_creator.dart';

/// Generates a new feature in the project by creating
/// data, domain, presentation layers, and injection files.
class GenerateCommand {
  /// Runs the generate command with the provided [args].
  ///
  /// The first argument in [args] should be the feature name.
  /// Example: `generate(['auth'])` will create a feature called "auth".
  /// If no name is provided, it prints an error message.
  void run(List<String> args) {
    if (args.isEmpty) {
      print('❌ Please provide a feature name');
      return;
    }

    final name = args.first;

    // Create folders and files layer by layer
    createDataLayer(name);
    createDomainLayer(name);
    createPresentationLayer(name);
    createInjectionFile(name);

    print('✅ Feature "$name" generated successfully!');
  }
}
