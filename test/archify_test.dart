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

    test('Init command creates archify.yaml only', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final result = Process.runSync('dart', [
        binPath,
        'init',
      ], workingDirectory: tempDir.path);

      expect(result.stdout.toString(), contains('Created archify.yaml'));
      expect(File('${tempDir.path}/archify.yaml').existsSync(), isTrue);
      expect(Directory('${tempDir.path}/lib').existsSync(), isFalse);
    });

    test('Configure command scaffolds the project', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      // No archify.yaml present, so this also exercises configure's
      // "run init now?" prompt (defaults to yes on the EOF stdin below).
      final result = Process.runSync('dart', [
        binPath,
        'configure',
      ], workingDirectory: tempDir.path);

      expect(
        result.stdout.toString(),
        contains('Project configured successfully'),
      );
      expect(File('${tempDir.path}/lib/main.dart').existsSync(), isTrue);
      expect(Directory('${tempDir.path}/lib/core').existsSync(), isTrue);
    });

    test('Templates command lists built-in template keys', () {
      final result = Process.runSync('dart', [binPath, 'templates']);
      final output = result.stdout.toString();

      expect(output, contains('main'));
      expect(output, contains('cubit'));
      expect(output, contains('Opt-in'));
    });

    test('Reset-project command resets lib/main.dart', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));
      File('${tempDir.path}/lib/main.dart').createSync(recursive: true);

      // Process.runSync doesn't connect a real stdin, so the confirmation
      // prompt's readLineSync() sees EOF immediately and falls back to its
      // default answer ("keep", moving lib/ to example/).
      final result = Process.runSync('dart', [
        binPath,
        'reset-project',
      ], workingDirectory: tempDir.path);

      expect(result.stdout.toString(), contains('reset to a fresh starter'));
      expect(
        File('${tempDir.path}/lib/main.dart').readAsStringSync(),
        contains('Edit lib/main.dart to get started'),
      );
    });
  });
}
