import 'package:archify/archify.dart';

void main() {
  final cli = ArchifyCLI();

  // Run configure
  cli.run(['configure']);

  // Run generate for "auth" feature
  cli.run(['generate', 'auth']);

  // Show version
  cli.run(['version']);
}
