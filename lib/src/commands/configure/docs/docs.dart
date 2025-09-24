import 'dart:io';

void updateDocs() {
  final docsFile = File('docs/ARCHITECTURE.md');
  const docsContent =
      '# Archify Architecture\n\nUse this to follow project conventions.';

  if (docsFile.existsSync()) {
    final current = docsFile.readAsStringSync();
    if (!current.contains(docsContent)) {
      docsFile.writeAsStringSync('$current\n\n$docsContent');
      print('📝 Updated docs/ARCHITECTURE.md');
    } else {
      print(
        '✅ docs/ARCHITECTURE.md already contains Archify section, skipping.',
      );
    }
  } else {
    docsFile.writeAsStringSync(docsContent);
    print('📝 Created docs/ARCHITECTURE.md');
  }
}
