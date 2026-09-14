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

    test('Init --arch mvvm writes the MVVM feature_template', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final result = Process.runSync('dart', [
        binPath,
        'init',
        '--arch',
        'mvvm',
      ], workingDirectory: tempDir.path);

      expect(result.stdout.toString(), contains('Created archify.yaml (MVVM)'));
      final yaml = File('${tempDir.path}/archify.yaml').readAsStringSync();
      expect(yaml, contains('viewmodel'));
      expect(yaml, isNot(contains('data_source_impl')));
    });

    test('Init --arch with an unknown value fails without writing a file', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final result = Process.runSync('dart', [
        binPath,
        'init',
        '--arch',
        'bogus',
      ], workingDirectory: tempDir.path);

      expect(result.stdout.toString(), contains('Unknown architecture'));
      expect(File('${tempDir.path}/archify.yaml').existsSync(), isFalse);
    });

    test('Generate produces model/viewmodel/view for an MVVM project', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      Process.runSync('dart', [
        binPath,
        'init',
        '--arch',
        'mvvm',
      ], workingDirectory: tempDir.path);
      final result = Process.runSync('dart', [
        binPath,
        'generate',
        'auth',
      ], workingDirectory: tempDir.path);

      expect(result.stdout.toString(), contains('generated successfully'));
      expect(
        File(
          '${tempDir.path}/lib/feature/auth/model/auth_model.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${tempDir.path}/lib/feature/auth/viewmodel/auth_viewmodel.dart',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${tempDir.path}/lib/feature/auth/view/auth_view.dart',
        ).existsSync(),
        isTrue,
      );
    });

    test(
      'Generate produces repository/service/controller/screen for a Feature-First project',
      () {
        final tempDir = Directory.systemTemp.createTempSync('archify_test_');
        addTearDown(() => tempDir.deleteSync(recursive: true));

        Process.runSync('dart', [
          binPath,
          'init',
          '--arch',
          'feature-first',
        ], workingDirectory: tempDir.path);
        final result = Process.runSync('dart', [
          binPath,
          'generate',
          'auth',
        ], workingDirectory: tempDir.path);

        expect(result.stdout.toString(), contains('generated successfully'));
        expect(
          File(
            '${tempDir.path}/lib/feature/auth/data/auth_repository.dart',
          ).existsSync(),
          isTrue,
        );
        expect(
          File(
            '${tempDir.path}/lib/feature/auth/application/auth_service.dart',
          ).existsSync(),
          isTrue,
        );
        expect(
          File(
            '${tempDir.path}/lib/feature/auth/presentation/controllers/auth_controller.dart',
          ).existsSync(),
          isTrue,
        );
        expect(
          File(
            '${tempDir.path}/lib/feature/auth/presentation/views/auth_screen.dart',
          ).existsSync(),
          isTrue,
        );
      },
    );

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

    test('Configure removes paths dropped from structure, with a backup', () {
      final tempDir = Directory.systemTemp.createTempSync('archify_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));
      final configPath = '${tempDir.path}/archify.yaml';
      final markerPath = '${tempDir.path}/lib/shared/theme/removal_test.md';

      Process.runSync('dart', [
        binPath,
        'init',
      ], workingDirectory: tempDir.path);

      // Add an extra (unmapped, so it's created empty) file to `structure`
      // and configure — establishes the manifest baseline that includes it.
      File(configPath).writeAsStringSync(
        File(configPath).readAsStringSync().replaceFirst(
          'app_colors.dart: theme_colors',
          'app_colors.dart: theme_colors\n        removal_test.md:',
        ),
      );
      Process.runSync('dart', [
        binPath,
        'configure',
      ], workingDirectory: tempDir.path);
      expect(File(markerPath).existsSync(), isTrue);

      // Remove it again and reconfigure — it should disappear from lib/ but
      // land in a recoverable backup instead of just vanishing.
      File(configPath).writeAsStringSync(
        File(configPath).readAsStringSync().replaceFirst(
          'app_colors.dart: theme_colors\n        removal_test.md:',
          'app_colors.dart: theme_colors',
        ),
      );
      final result = Process.runSync('dart', [
        binPath,
        'configure',
      ], workingDirectory: tempDir.path);

      expect(result.stdout.toString(), contains('backed up'));
      expect(File(markerPath).existsSync(), isFalse);

      final backups = Directory('${tempDir.path}/.archify/removed')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('removal_test.md'));
      expect(backups, isNotEmpty);
    });

    test(
      'Generate removes paths dropped from feature_template, with a backup',
      () {
        final tempDir = Directory.systemTemp.createTempSync('archify_test_');
        addTearDown(() => tempDir.deleteSync(recursive: true));
        final configPath = '${tempDir.path}/archify.yaml';
        final widgetDirPath =
            '${tempDir.path}/lib/feature/auth/presentation/widget';

        Process.runSync('dart', [
          binPath,
          'init',
        ], workingDirectory: tempDir.path);
        Process.runSync('dart', [
          binPath,
          'generate',
          'auth',
        ], workingDirectory: tempDir.path);
        expect(Directory(widgetDirPath).existsSync(), isTrue);

        // Drop the `widget:` folder from feature_template and regenerate —
        // it should be pulled out of the feature, not left stale.
        File(configPath).writeAsStringSync(
          File(configPath).readAsStringSync().replaceFirst(
            '"{feature_name}_page.dart": page\n      widget:\n',
            '"{feature_name}_page.dart": page\n',
          ),
        );
        final result = Process.runSync('dart', [
          binPath,
          'generate',
          'auth',
        ], workingDirectory: tempDir.path);

        expect(result.stdout.toString(), contains('backed up'));
        expect(Directory(widgetDirPath).existsSync(), isFalse);
        expect(
          Directory('${tempDir.path}/.archify/removed').existsSync(),
          isTrue,
        );
      },
    );

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
