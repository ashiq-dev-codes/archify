import 'package:archify/archify.dart';

void main() {
  final cli = ArchifyCLI();

  // Configure the base project structure
  cli.run(['configure']);

  // Generate a standard feature/module called "auth"
  cli.run(['generate', 'auth']);

  // Generate a custom feature using a YAML template
  // Make sure to replace "custom_feature" and path with your own values
  cli.run([
    'custom',
    'custom_feature',
    '--template',
    'arch/custom_feature_template.yaml',
  ]);

  // Show the current Archify CLI version
  cli.run(['version']);
}
