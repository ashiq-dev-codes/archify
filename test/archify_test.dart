import 'dart:io';

import 'package:archify/archify.dart';
import 'package:test/test.dart';

void main() {
  // Absolute path so the CLI can still be found once we run it against a
  // scratch working directory instead of this package's own repo.
  final binPath = File('bin/archify.dart').absolute.path;

  group('Archify CLI Tests', () {
    test('Version command returns correct version', () {
      final version = getCliVersion();
      expect(version, packageVersion);
    });

    test('Unknown command prints error', () {
      final result = Process.runSync('dart', [binPath, 'unknown']);
      expect(result.stdout.toString(), contains('Unknown command'));
    });

    test('Generate command with no feature fails', () {
      final result = Process.runSync('dart', [binPath, 'generate']);
      expect(
        result.stdout.toString(),
        contains('Please provide a feature name'),
      );
    });

    test('Generate command with feature runs', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final result = Process.runSync('dart', [
        binPath,
        'generate',
        'auth',
      ], workingDirectory: tempDir.path);
      expect(result.stdout.toString(), contains('generated successfully'));
    });

    test('Configure command runs', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final result = Process.runSync('dart', [
        binPath,
        'configure',
      ], workingDirectory: tempDir.path);
      expect(result.stdout.toString(), contains('archify.yaml'));
    });
  });
}
