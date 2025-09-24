import 'dart:io';

void updateReadme() {
  final readme = File('README.md');
  const archifyText = '## Archify\nThis project uses Archify CLI.';

  if (readme.existsSync()) {
    final content = readme.readAsStringSync();
    if (!content.contains(archifyText)) {
      readme.writeAsStringSync('$content\n\n$archifyText');
      print('📄 Updated README.md');
    } else {
      print('✅ README.md already contains Archify section, skipping.');
    }
  } else {
    readme.writeAsStringSync(archifyText);
    print('📄 Created README.md with Archify section');
  }
}
