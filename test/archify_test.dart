import 'dart:io';

import 'package:archify/archify.dart';
import 'package:test/test.dart';

void main() {
  group('Archify CLI Tests', () {
    test('Version command returns correct version', () {
      final version = getCliVersion();
      expect(version, packageVersion);
    });

    test('Unknown command prints error', () {
      final result = Process.runSync('dart', ['bin/archify.dart', 'unknown']);
      expect(result.stdout.toString(), contains('Unknown command'));
    });

    test('Generate command with no feature fails', () {
      final result = Process.runSync('dart', ['bin/archify.dart', 'generate']);
      expect(
        result.stdout.toString(),
        contains('Usage: archify generate <feature>'),
      );
    });

    test('Generate command with feature runs', () {
      final result = Process.runSync('dart', [
        'bin/archify.dart',
        'generate',
        'auth',
      ]);
      expect(result.stdout.toString(), contains('🚀 Generating feature: auth'));
    });

    test('Configure command runs', () {
      final result = Process.runSync('dart', ['bin/archify.dart', 'configure']);
      expect(result.stdout.toString(), contains('⚙️  Running configure'));
    });
  });
}
