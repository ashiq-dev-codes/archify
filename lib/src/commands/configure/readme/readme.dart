import 'dart:io';

/// Entry point
void main() {
  updateReadme();
}

/// Updates the project README with Archify usage instructions.
/// If the section exists → replaces it.
/// If not → appends it.
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
''';

  if (readme.existsSync()) {
    var content = readme.readAsStringSync();
    // Match "## Archify" section until the next heading or EOF
    final regex = RegExp(
      r'## Archify[\s\S]*?(?=\n## |\n# |\$)',
      multiLine: true,
    );

    if (regex.hasMatch(content)) {
      // Replace existing section
      content = content.replaceFirst(regex, archifySection.trim());
      readme.writeAsStringSync(content);
      print('🔄 Updated Archify section in README.md');
    } else {
      // Append new section
      readme.writeAsStringSync('$content\n\n$archifySection');
      print('📄 Added Archify section to README.md');
    }
  } else {
    // Create fresh README
    readme.writeAsStringSync('# Project\n\n$archifySection');
    print('📄 Created README.md with Archify section');
  }
}
