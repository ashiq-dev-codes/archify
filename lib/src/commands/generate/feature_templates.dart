import 'package:archify/src/commands/configure/config/template_spec.dart';
import 'package:archify/src/extensions/string_extensions.dart';

typedef FeatureTemplateBuilder =
    String Function({
      required String packageName,
      required String featureName,
      required String importRoot,
    });

/// Built-in content generators for `archify.yaml`'s `feature_template` file
/// nodes — the single source of truth for both [renderFeatureTemplate] and
/// `dart run archify templates`.
///
/// [importRoot] is `feature_root` (from `archify.yaml`) with a leading
/// `lib/` stripped, e.g. `feature_root: lib/feature` → `importRoot: feature`
/// — used to build `package:<name>/...` imports that stay correct even if
/// the developer renames `feature_root`.
final Map<String, TemplateSpec<FeatureTemplateBuilder>> featureTemplates = {
  'data_source': const TemplateSpec(
    description: 'Abstract data source interface',
    isDefault: true,
    build: _dataSource,
  ),
  'data_source_impl': const TemplateSpec(
    description: 'Data source implementation',
    isDefault: true,
    build: _dataSourceImpl,
  ),
  'repo': const TemplateSpec(
    description: 'Abstract repository interface',
    isDefault: true,
    build: _repo,
  ),
  'repo_impl': const TemplateSpec(
    description: 'Repository implementation',
    isDefault: true,
    build: _repoImpl,
  ),
  'page': const TemplateSpec(
    description: 'Blank StatelessWidget screen',
    isDefault: true,
    build: _page,
  ),
  'cubit': const TemplateSpec(
    description: 'Bloc Cubit (needs equatable, flutter_bloc)',
    isDefault: false,
    build: _cubit,
  ),
  'cubit_state': const TemplateSpec(
    description: 'Cubit state classes (needs equatable)',
    isDefault: false,
    build: _cubitState,
  ),
  'feature_injection': const TemplateSpec(
    description:
        'GetIt/Bloc wiring into injection_container.dart + app.dart (needs get_it, flutter_bloc)',
    isDefault: false,
    build: _featureInjection,
  ),
};

/// An unrecognized key resolves to `null`, and the caller creates an empty
/// file instead.
String? renderFeatureTemplate(
  String key, {
  required String packageName,
  required String featureName,
  required String importRoot,
}) {
  final spec = featureTemplates[key];
  if (spec == null) return null;
  return spec.build(
    packageName: packageName,
    featureName: featureName,
    importRoot: importRoot,
  );
}

String _dataSource({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
abstract class ${featureName.toPascalCase()}DataSource {
  // Add your data source here
}
''';

String _repo({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
abstract class ${featureName.toPascalCase()}Repo {
  // Add your repo here
}
''';

String _dataSourceImpl({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/$importRoot/$featureName/domain/data_source/${featureName}_data_source.dart';

class ${featureName.toPascalCase()}DataSourceImpl implements ${featureName.toPascalCase()}DataSource {
  // Add your data source implementation here
}
''';

String _repoImpl({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/$importRoot/$featureName/domain/data_source/${featureName}_data_source.dart';
import 'package:$packageName/$importRoot/$featureName/domain/repo/${featureName}_repo.dart';

class ${featureName.toPascalCase()}RepoImpl implements ${featureName.toPascalCase()}Repo {
  ${featureName.toPascalCase()}RepoImpl({required this.remote});
  final ${featureName.toPascalCase()}DataSource remote;

  // Add your repo implementation here
}
''';

String _cubit({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/$importRoot/$featureName/domain/repo/${featureName}_repo.dart';

part '${featureName}_state.dart';

class ${featureName.toPascalCase()}Cubit extends Cubit<${featureName.toPascalCase()}State> {
  ${featureName.toPascalCase()}Cubit({required this.repo}) : super(${featureName.toPascalCase()}Initial());
  final ${featureName.toPascalCase()}Repo repo;

  void get clear {
    emit(${featureName.toPascalCase()}Initial());
  }

  // Add your bloc functions here
}
''';

String _cubitState({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
part of '${featureName}_cubit.dart';

abstract class ${featureName.toPascalCase()}State extends Equatable {
  const ${featureName.toPascalCase()}State();

  @override
  List<Object> get props => [];
}

class ${featureName.toPascalCase()}Initial extends ${featureName.toPascalCase()}State {}

class ${featureName.toPascalCase()}Loading extends ${featureName.toPascalCase()}State {}

class ${featureName.toPascalCase()}Success extends ${featureName.toPascalCase()}State {
  final Object object;
  const ${featureName.toPascalCase()}Success({required this.object});

  @override
  List<Object> get props => [object];
}

class ${featureName.toPascalCase()}Failure extends ${featureName.toPascalCase()}State {
  final Object error;
  const ${featureName.toPascalCase()}Failure({required this.error});

  @override
  List<Object> get props => [error];
}
''';

String _page({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:flutter/material.dart';

class ${featureName.toPascalCase()}Screen extends StatelessWidget {
  const ${featureName.toPascalCase()}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Placeholder());
  }
}
''';

String _featureInjection({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:$packageName/$importRoot/$featureName/data/data_source_impl/${featureName}_data_source_impl.dart';
import 'package:$packageName/$importRoot/$featureName/data/repo_impl/${featureName}_repo_impl.dart';
import 'package:$packageName/$importRoot/$featureName/domain/data_source/${featureName}_data_source.dart';
import 'package:$packageName/$importRoot/$featureName/domain/repo/${featureName}_repo.dart';
import 'package:$packageName/$importRoot/$featureName/presentation/cubit/${featureName}_cubit.dart';
import 'package:$packageName/injection_container.dart';

Future<void> init${featureName.toPascalCase()}Injection(GetIt sl) async {
  //* Blocs
  sl.registerLazySingleton(() => ${featureName.toPascalCase()}Cubit(repo: sl()));

  //* Use cases

  //* Repository
  sl.registerLazySingleton<${featureName.toPascalCase()}Repo>(() => ${featureName.toPascalCase()}RepoImpl(remote: sl()));

  //* Data sources
  sl.registerLazySingleton<${featureName.toPascalCase()}DataSource>(() => ${featureName.toPascalCase()}DataSourceImpl());
}

void clear${featureName.toPascalCase()}(BuildContext context) {
  context.read<${featureName.toPascalCase()}Cubit>().clear;
}

List<BlocProvider<Cubit<Object>>> ${featureName.toCamelCase()}Blocs(
  BuildContext context,
) => <BlocProvider<Cubit<Object>>>[
  BlocProvider<${featureName.toPascalCase()}Cubit>(create: (BuildContext context) => sl<${featureName.toPascalCase()}Cubit>()),
];
''';
