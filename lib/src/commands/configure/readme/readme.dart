import 'dart:io';

/// Updates the project README with Archify usage instructions.
void updateReadme() {
  final readme = File('README.md');

  const archifySection = '''
## Archify

This project uses **Archify CLI** for clean architecture scaffolding.

### 🚀 Usage

Run the CLI from the root of your project:

```bash
# Configure project base folders
dart run archify configure

# Generate a new feature/module (example: auth)
dart run archify generate auth
```
''';

  if (readme.existsSync()) {
    final content = readme.readAsStringSync();

    if (!content.contains('## Archify')) {
      readme.writeAsStringSync('$content\n\n$archifySection');
      print('📄 Updated README.md with Archify section');
    } else {
      print('✅ README.md already contains Archify section, skipping.');
    }
  } else {
    readme.writeAsStringSync('# Project\n\n$archifySection');
    print('📄 Created README.md with Archify section');
  }
}
