import 'package:archify/src/commands/init/config/ddd_architecture.dart';
import 'package:archify/src/commands/init/config/feature_first_architecture.dart';
import 'package:archify/src/commands/init/config/mvvm_architecture.dart';

/// One architecture `dart run archify init` can scaffold `archify.yaml`
/// from.
class ArchitecturePreset {
  const ArchitecturePreset({
    required this.label,
    required this.description,
    required this.archifyYaml,
  });

  /// Short display name, e.g. `DDD / Clean Architecture`.
  final String label;

  /// One-line description shown in the `init` picker.
  final String description;

  /// The full `archify.yaml` content this preset writes.
  final String archifyYaml;
}

/// The preset `init` uses when none is picked (`--arch` omitted and the
/// interactive prompt gets a blank/EOF answer) — keeps `init`'s existing
/// behavior unchanged for anyone not opting into a different architecture.
const defaultArchitectureKey = 'ddd';

/// Every architecture `init` can scaffold from, keyed by the value passed to
/// `--arch` (or typed at the interactive prompt). Add an entry here to make
/// a new architecture available — nothing else needs to know about it.
final Map<String, ArchitecturePreset> architecturePresets = {
  'ddd': const ArchitecturePreset(
    label: 'DDD / Clean Architecture',
    description:
        'data/domain/presentation per feature, repo + data source pattern',
    archifyYaml: dddArchifyConfig,
  ),
  'mvvm': const ArchitecturePreset(
    label: 'MVVM',
    description: 'model/view/viewmodel per feature, ChangeNotifier-based state',
    archifyYaml: mvvmArchifyConfig,
  ),
  'feature-first': const ArchitecturePreset(
    label: 'Feature-First',
    description:
        'flatter than DDD — one repository, a service layer shared across screens',
    archifyYaml: featureFirstArchifyConfig,
  ),
};
