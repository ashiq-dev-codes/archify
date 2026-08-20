import 'package:archify/archify.dart';

void main() {
  final cli = ArchifyCLI();

  // Create archify.yaml describing the project's architecture (DDD by default)
  cli.run(['init']);

  // Scaffold the project from archify.yaml — customize the file first if you
  // want a different architecture (MVVM, MVC, etc.), Archify just follows it
  cli.run(['configure']);

  // Generate a feature/module called "auth", following archify.yaml's
  // feature_template section
  cli.run(['generate', 'auth']);

  // List every built-in template key archify.yaml can reference
  cli.run(['templates']);

  // Generate a fully custom feature using an ad hoc YAML template
  // Make sure to replace "custom_feature" and path with your own values
  cli.run([
    'custom',
    'custom_feature',
    '--template',
    'arch/custom_feature_template.yaml',
  ]);

  // Show the current Archify CLI version
  cli.run(['version']);

  // Resets lib/ to a blank starter screen (moves existing code to example/
  // by default) — left commented out since it would undo everything above
  // cli.run(['reset-project']);
}
