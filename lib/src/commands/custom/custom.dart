import 'dart:io';

import 'package:archify/src/commands/custom/custom_creator.dart';

class CustomCommand {
  void run(List<String> args) {
    if (args.isEmpty) {
      print('❌ Feature name and template path are required.');
      print('Usage: archify custom <feature> --template path/to/template.yaml');
      return;
    }

    final featureName = args.first;

    // Look for --template option
    final templateIndex = args.indexOf('--template');
    if (templateIndex == -1 || templateIndex + 1 >= args.length) {
      print('❌ Template path is required.');
      print('Usage: archify custom <feature> --template path/to/template.yaml');
      return;
    }

    final templatePath = args[templateIndex + 1];

    final featureDir = Directory('lib/$featureName');

    if (featureDir.existsSync()) {
      // Prompt user
      stdout.write(
        'Feature "$featureName" already exists. Do you want to recreate it? [y/N]: ',
      );
      final response = stdin.readLineSync();
      if (response == null || response.toLowerCase() != 'y') {
        print('❌ Generation aborted.');
        return;
      }

      // Backup old folder
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final backupDir = Directory('lib/${featureName}_backup_$timestamp');
      featureDir.renameSync(backupDir.path);
      print('✅ Old feature backed up as: ${backupDir.path}');
    }

    try {
      createCustomFeature(featureName: featureName, templatePath: templatePath);
      print('✅ Custom feature "$featureName" generated successfully.');
    } catch (e) {
      print('❌ Failed to generate feature: $e');
    }
  }
}
