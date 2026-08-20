import 'package:archify/src/commands/configure/config/template_spec.dart';
import 'package:archify/src/commands/configure/config/templates.dart';
import 'package:archify/src/commands/generate/feature_templates.dart';

/// Lists every built-in `template:` key, read straight from the same
/// registries `configure`/`generate` dispatch against — always accurate,
/// never a hand-maintained list to fall out of sync.
class TemplatesCommand {
  void run() {
    print('Structure templates (archify.yaml "structure" → `configure`):');
    _printGroup(structureTemplates);
    print('');
    print('Feature templates (archify.yaml "feature_template" → `generate`):');
    _printGroup(featureTemplates);
    print('');
    print('A file with no template key is created empty.');
  }

  void _printGroup(Map<String, TemplateSpec> specs) {
    final defaults = specs.entries.where((e) => e.value.isDefault).toList();
    final optIns = specs.entries.where((e) => !e.value.isDefault).toList();
    final width = specs.keys
        .map((k) => k.length)
        .reduce((a, b) => a > b ? a : b);

    if (defaults.isNotEmpty) {
      print('  In the default archify.yaml:');
      for (final e in defaults) {
        print('    ${e.key.padRight(width)}   ${e.value.description}');
      }
    }
    if (optIns.isNotEmpty) {
      print('  Opt-in (add the node yourself):');
      for (final e in optIns) {
        print('    ${e.key.padRight(width)}   ${e.value.description}');
      }
    }
  }
}
