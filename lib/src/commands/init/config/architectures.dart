import 'package:archify/src/commands/init/config/ddd_architecture.dart';
import 'package:archify/src/commands/init/config/feature_first_architecture.dart';
import 'package:archify/src/commands/init/config/mvc_architecture.dart';
import 'package:archify/src/commands/init/config/mvvm_architecture.dart';
import 'package:archify/src/commands/init/config/vgv_bloc_architecture.dart';

/// One architecture `dart run archify init` can scaffold `archify.yaml`
/// from.
class ArchitecturePreset {
  const ArchitecturePreset({
    required this.label,
    required this.description,
    required this.archifyYaml,
    this.packageNote,
  });

  /// Short display name, e.g. `DDD / Clean Architecture`.
  final String label;

  /// One-line description shown in the `init` picker.
  final String description;

  /// The full `archify.yaml` content this preset writes.
  final String archifyYaml;

  /// Printed by `init` right after writing `archify.yaml`, for a preset
  /// that (unlike the rest) genuinely needs a package from the very first
  /// generated feature — e.g. VGV-Bloc needs `flutter_bloc`. `null` for a
  /// preset that needs nothing beyond the Flutter SDK.
  final String? packageNote;
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
  'mvc': const ArchitecturePreset(
    label: 'MVC',
    description:
        'the lightest preset — a plain Controller, the View manages its own setState',
    archifyYaml: mvcArchifyConfig,
  ),
  'vgv-bloc': const ArchitecturePreset(
    label: 'VGV-Bloc',
    description:
        'Page/View split, full Bloc (Event/State) — needs flutter_bloc',
    archifyYaml: vgvBlocArchifyConfig,
    packageNote:
        'This one genuinely needs a package from the first feature you '
        'generate: run `flutter pub add flutter_bloc equatable`.',
  ),
};
