import 'dart:io';

import 'package:archify/src/commands/configure/configure.dart';
import 'package:archify/src/commands/generate/feature_templates.dart';
import 'package:archify/src/commands/generate/injection_wiring.dart';
import 'package:archify/src/utils/fs_utils.dart';
import 'package:archify/src/utils/yaml_tree.dart';
import 'package:yaml/yaml.dart';

/// Generates a new feature from the `feature_template` section of
/// `archify.yaml`.
class GenerateCommand {
  /// Runs the generate command with the provided [args].
  ///
  /// The first argument in [args] should be the feature name. If
  /// `archify.yaml` doesn't exist yet, prompts to run `configure` first
  /// (which creates it) before continuing with generation.
  void run(List<String> args) {
    if (args.isEmpty) {
      print('❌ Please provide a feature name');
      return;
    }

    final featureName = args.first;
    final configFile = File('archify.yaml');

    if (!configFile.existsSync()) {
      print(
        '❌ No archify.yaml found. Run `dart run archify configure` first to create it.',
      );

      final proceed = _askForConfirmation('Run configure now? [Y/n]: ');
      if (!proceed) {
        print('❌ Generation cancelled.');
        return;
      }

      ConfigureCommand().run();

      if (!configFile.existsSync()) {
        print('❌ archify.yaml still not found after running configure.');
        return;
      }
    }

    try {
      _generateFeature(configFile, featureName);
    } catch (e) {
      print('❌ Failed to generate feature: $e');
      return;
    }

    print('✅ Feature "$featureName" generated successfully!');
  }

  void _generateFeature(File configFile, String featureName) {
    final dynamic doc = loadYaml(configFile.readAsStringSync());

    if (doc is! Map || doc['feature_template'] is! List) {
      throw Exception(
        '"feature_template" section missing or invalid in archify.yaml. '
        'Delete archify.yaml and run `configure` again to regenerate the '
        'default, or add a "feature_template" section yourself.',
      );
    }

    final featureRoot = doc['feature_root']?.toString() ?? 'lib/feature';
    final importRoot =
        featureRoot.startsWith('lib/') ? featureRoot.substring(4) : featureRoot;
    final packageName = getPackageName();

    String? injectionFilePath;

    walkYamlTree(
      featureRoot,
      doc['feature_template'],
      transformName: (name) => name.replaceAll('{feature_name}', featureName),
      resolveFileContent: (path, node) {
        final templateKey = node['template']?.toString();
        if (templateKey == null) return null;

        final rendered = renderFeatureTemplate(
          templateKey,
          packageName: packageName,
          featureName: featureName,
          importRoot: importRoot,
        );

        if (rendered == null) {
          print(
            '⚠️ Unknown template "$templateKey" for "$path", creating empty file.',
          );
          return null;
        }

        if (templateKey == 'feature_injection') injectionFilePath = path;
        return rendered;
      },
    );

    final generatedInjectionPath = injectionFilePath;
    if (generatedInjectionPath != null) {
      final importPath =
          generatedInjectionPath.startsWith('lib/')
              ? generatedInjectionPath.substring(4)
              : generatedInjectionPath;

      updateInjectionContainer(
        packageName: packageName,
        featureName: featureName,
        injectionImportPath: importPath,
      );
      updateAppBlocs(
        packageName: packageName,
        featureName: featureName,
        injectionImportPath: importPath,
      );
    }
  }

  /// Prompts user for confirmation, defaulting to "yes" on empty input.
  bool _askForConfirmation(String message) {
    stdout.write(message);
    final input = stdin.readLineSync()?.trim().toLowerCase() ?? '';
    return input != 'n' && input != 'no';
  }
}
