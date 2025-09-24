import 'package:archify/archify.dart';

class GenerateCommand {
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
