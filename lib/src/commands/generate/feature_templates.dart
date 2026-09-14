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
  'entity': const TemplateSpec(
    description: 'Domain entity (DDD)',
    isDefault: true,
    build: _entity,
  ),
  'data_model': const TemplateSpec(
    description: 'Data-layer model extending the entity (DDD)',
    isDefault: true,
    build: _dataModel,
  ),
  'data_source': const TemplateSpec(
    description: 'Abstract remote data source interface (DDD)',
    isDefault: true,
    build: _dataSource,
  ),
  'data_source_impl': const TemplateSpec(
    description: 'Remote data source implementation (DDD)',
    isDefault: true,
    build: _dataSourceImpl,
  ),
  'repo': const TemplateSpec(
    description: 'Abstract repository interface (DDD)',
    isDefault: true,
    build: _repo,
  ),
  'repo_impl': const TemplateSpec(
    description: 'Repository implementation — data source + NetworkInfo (DDD)',
    isDefault: true,
    build: _repoImpl,
  ),
  'usecase': const TemplateSpec(
    description: 'Use case composing the repository (DDD)',
    isDefault: true,
    build: _useCase,
  ),
  'page': const TemplateSpec(
    description: 'Blank StatelessWidget screen',
    isDefault: true,
    build: _page,
  ),
  'model': const TemplateSpec(
    description: 'Plain data model (MVVM)',
    isDefault: false,
    build: _model,
  ),
  'repository': const TemplateSpec(
    description: 'Repository using NetworkInfo (MVVM)',
    isDefault: false,
    build: _mvvmRepository,
  ),
  'viewmodel': const TemplateSpec(
    description:
        'ChangeNotifier view model wired to its repository (MVVM, no package needed)',
    isDefault: false,
    build: _viewModel,
  ),
  'view': const TemplateSpec(
    description: 'StatefulWidget view wired to its ViewModel (MVVM)',
    isDefault: false,
    build: _view,
  ),
  'cubit': const TemplateSpec(
    description:
        'Bloc Cubit wired to its use case (needs equatable, flutter_bloc)',
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

String _entity({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
class ${featureName.toPascalCase()}Entity {
  const ${featureName.toPascalCase()}Entity();

  // Add your entity fields here — the plain, framework-free shape of this
  // feature's data, as the domain layer sees it
}
''';

String _dataModel({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/$importRoot/$featureName/domain/entities/${featureName}_entity.dart';

/// The data layer's shape of ${featureName.toPascalCase()}Entity — add
/// fromJson/toJson (or your serialization format) here, then map to/from
/// ${featureName.toPascalCase()}Entity.
class ${featureName.toPascalCase()}Model extends ${featureName.toPascalCase()}Entity {
  const ${featureName.toPascalCase()}Model();

  // Add your fromJson/toJson (or similar) here
}
''';

String _dataSource({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
abstract class ${featureName.toPascalCase()}RemoteDataSource {
  // Add your remote calls here — throw a ServerException on failure, the
  // repository maps it to a Failure for the rest of the app to handle
}
''';

String _dataSourceImpl({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/$importRoot/$featureName/data/datasources/${featureName}_remote_data_source.dart';

class ${featureName.toPascalCase()}RemoteDataSourceImpl
    implements ${featureName.toPascalCase()}RemoteDataSource {
  // Add your http client (e.g. Dio) dependency here

  // Add your remote call implementations here
}
''';

String _repo({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
abstract class ${featureName.toPascalCase()}Repository {
  // Add your repository methods here, returning Result<T> from
  // core/error/failures.dart so callers can handle failure without
  // try/catch, e.g.:
  // Future<Result<${featureName.toPascalCase()}Entity>> get${featureName.toPascalCase()}();
}
''';

String _repoImpl({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/core/network/network_info.dart';
import 'package:$packageName/$importRoot/$featureName/data/datasources/${featureName}_remote_data_source.dart';
import 'package:$packageName/$importRoot/$featureName/domain/repositories/${featureName}_repository.dart';

class ${featureName.toPascalCase()}RepositoryImpl
    implements ${featureName.toPascalCase()}Repository {
  ${featureName.toPascalCase()}RepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final ${featureName.toPascalCase()}RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  // Implement the methods declared in ${featureName.toPascalCase()}Repository
  // here — check networkInfo.isConnected before calling remoteDataSource,
  // and map a ServerException to a ServerFailure (see core/error)
}
''';

String _useCase({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/$importRoot/$featureName/domain/repositories/${featureName}_repository.dart';

class ${featureName.toPascalCase()}UseCase {
  const ${featureName.toPascalCase()}UseCase(this.repository);

  final ${featureName.toPascalCase()}Repository repository;

  // Add your use case call(s) here — one per action this feature exposes
  // to the presentation layer, e.g. call() or get/update/delete methods
}
''';

String _cubit({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/$importRoot/$featureName/domain/usecases/${featureName}_usecase.dart';

part '${featureName}_state.dart';

class ${featureName.toPascalCase()}Cubit extends Cubit<${featureName.toPascalCase()}State> {
  ${featureName.toPascalCase()}Cubit({required this.useCase})
    : super(${featureName.toPascalCase()}Initial());
  final ${featureName.toPascalCase()}UseCase useCase;

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

String _model({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
class ${featureName.toPascalCase()}Model {
  const ${featureName.toPascalCase()}Model();

  // Add your fields here, plus fromJson/toJson if this is fetched from an API
}
''';

String _mvvmRepository({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:$packageName/core/network/network_info.dart';

class ${featureName.toPascalCase()}Repository {
  const ${featureName.toPascalCase()}Repository({required this.networkInfo});

  final NetworkInfo networkInfo;

  // Add your data access here (API calls, local storage, ...), returning
  // Result<${featureName.toPascalCase()}Model> (see core/error/failures.dart
  // and ../model/${featureName}_model.dart) so the view model can handle
  // failure without try/catch
}
''';

String _viewModel({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:flutter/foundation.dart';
import 'package:$packageName/$importRoot/$featureName/repository/${featureName}_repository.dart';

class ${featureName.toPascalCase()}ViewModel extends ChangeNotifier {
  ${featureName.toPascalCase()}ViewModel({required this.repository});

  final ${featureName.toPascalCase()}Repository repository;

  bool isLoading = false;
  Object? error;

  // Add your view state (e.g. the fetched ${featureName.toPascalCase()}Model)
  // and logic here — call notifyListeners() after each change
}
''';

String _view({
  required String packageName,
  required String featureName,
  required String importRoot,
}) => '''
import 'package:flutter/material.dart';
import 'package:$packageName/core/network/network_info.dart';
import 'package:$packageName/$importRoot/$featureName/repository/${featureName}_repository.dart';
import 'package:$packageName/$importRoot/$featureName/viewmodel/${featureName}_viewmodel.dart';

class ${featureName.toPascalCase()}View extends StatefulWidget {
  const ${featureName.toPascalCase()}View({super.key});

  @override
  State<${featureName.toPascalCase()}View> createState() =>
      _${featureName.toPascalCase()}ViewState();
}

class _${featureName.toPascalCase()}ViewState extends State<${featureName.toPascalCase()}View> {
  final _viewModel = ${featureName.toPascalCase()}ViewModel(
    repository: ${featureName.toPascalCase()}Repository(
      networkInfo: const NetworkInfoImpl(),
    ),
  );

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => Placeholder(),
      ),
    );
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
import 'package:$packageName/$importRoot/$featureName/data/datasources/${featureName}_remote_data_source.dart';
import 'package:$packageName/$importRoot/$featureName/data/datasources/${featureName}_remote_data_source_impl.dart';
import 'package:$packageName/$importRoot/$featureName/data/repositories/${featureName}_repository_impl.dart';
import 'package:$packageName/$importRoot/$featureName/domain/repositories/${featureName}_repository.dart';
import 'package:$packageName/$importRoot/$featureName/domain/usecases/${featureName}_usecase.dart';
import 'package:$packageName/$importRoot/$featureName/presentation/cubit/${featureName}_cubit.dart';
import 'package:$packageName/injection_container.dart';

Future<void> init${featureName.toPascalCase()}Injection(GetIt sl) async {
  //* Blocs
  sl.registerLazySingleton(() => ${featureName.toPascalCase()}Cubit(useCase: sl()));

  //* Use cases
  sl.registerLazySingleton(() => ${featureName.toPascalCase()}UseCase(sl()));

  //* Repository
  sl.registerLazySingleton<${featureName.toPascalCase()}Repository>(
    () => ${featureName.toPascalCase()}RepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //* Data sources
  sl.registerLazySingleton<${featureName.toPascalCase()}RemoteDataSource>(
    () => ${featureName.toPascalCase()}RemoteDataSourceImpl(),
  );
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
