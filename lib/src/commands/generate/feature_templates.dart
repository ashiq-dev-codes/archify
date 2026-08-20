import 'package:archify/src/extensions/string_extensions.dart';

/// Built-in content generators for `archify.yaml`'s `feature_template`
/// file nodes.
///
/// [importRoot] is [featureRoot] (from `archify.yaml`) with a leading `lib/`
/// stripped, e.g. `feature_root: lib/feature` → `importRoot: feature` — used
/// to build `package:<name>/...` imports that stay correct even if the
/// developer renames `feature_root`.
///
/// An unrecognized key resolves to `null`, and the caller creates an empty
/// file instead.
String? renderFeatureTemplate(
  String key, {
  required String packageName,
  required String featureName,
  required String importRoot,
}) {
  switch (key) {
    case 'data_source':
      return _dataSource(featureName);
    case 'repo':
      return _repo(featureName);
    case 'data_source_impl':
      return _dataSourceImpl(packageName, featureName, importRoot);
    case 'repo_impl':
      return _repoImpl(packageName, featureName, importRoot);
    case 'cubit':
      return _cubit(packageName, featureName, importRoot);
    case 'cubit_state':
      return _cubitState(featureName);
    case 'page':
      return _page(featureName);
    case 'feature_injection':
      return _featureInjection(packageName, featureName, importRoot);
    default:
      return null;
  }
}

String _dataSource(String featureName) => '''
abstract class ${featureName.toPascalCase()}DataSource {
  // Add your data source here
}
''';

String _repo(String featureName) => '''
abstract class ${featureName.toPascalCase()}Repo {
  // Add your repo here
}
''';

String _dataSourceImpl(
  String packageName,
  String featureName,
  String importRoot,
) => '''
import 'package:$packageName/$importRoot/$featureName/domain/data_source/${featureName}_data_source.dart';

class ${featureName.toPascalCase()}DataSourceImpl implements ${featureName.toPascalCase()}DataSource {
  // Add your data source implementation here
}
''';

String _repoImpl(String packageName, String featureName, String importRoot) =>
    '''
import 'package:$packageName/$importRoot/$featureName/domain/data_source/${featureName}_data_source.dart';
import 'package:$packageName/$importRoot/$featureName/domain/repo/${featureName}_repo.dart';

class ${featureName.toPascalCase()}RepoImpl implements ${featureName.toPascalCase()}Repo {
  ${featureName.toPascalCase()}RepoImpl({required this.remote});
  final ${featureName.toPascalCase()}DataSource remote;

  // Add your repo implementation here
}
''';

String _cubit(String packageName, String featureName, String importRoot) => '''
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

String _cubitState(String featureName) => '''
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

String _page(String featureName) => '''
import 'package:flutter/material.dart';

class ${featureName.toPascalCase()}Screen extends StatelessWidget {
  const ${featureName.toPascalCase()}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Placeholder());
  }
}
''';

String _featureInjection(
  String packageName,
  String featureName,
  String importRoot,
) => '''
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
