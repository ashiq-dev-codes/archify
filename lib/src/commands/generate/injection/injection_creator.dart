import 'package:archify/archify.dart';
import 'package:archify/src/extensions/string_extensions.dart';

void createInjectionFile(String featureName) {
  final packageName = getPackageName();
  final path = 'lib/features/$featureName/${featureName}_injection.dart';

  createFile(path, '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:$packageName/features/$featureName/data/data_source_impl/${featureName}_data_source_impl.dart';
import 'package:$packageName/features/$featureName/data/repo_impl/${featureName}_repo_impl.dart';
import 'package:$packageName/features/$featureName/domain/data_source/${featureName}_data_source.dart';
import 'package:$packageName/features/$featureName/domain/repo/${featureName}_repo.dart';
import 'package:$packageName/features/$featureName/presentation/cubit/${featureName}_cubit.dart';
import 'package:$packageName/injection_container.dart';


Future<void> init${featureName.capitalize()}Injection(GetIt sl) async {
  //* Blocs
  sl.registerLazySingleton(() => ${featureName.capitalize()}Cubit(repo: sl()));

  //* Use cases

  //* Repository
  sl.registerLazySingleton<${featureName.capitalize()}Repo>(() => ${featureName.capitalize()}RepoImpl(remote: sl()));

  //* Data sources
  sl.registerLazySingleton<${featureName.capitalize()}DataSource>(() => ${featureName.capitalize()}DataSourceImpl());
}

void clear${featureName.capitalize()}(BuildContext context) {
  context.read<${featureName.capitalize()}Cubit>().clear;
}

List<BlocProvider<Cubit<Object>>> ${featureName}Blocs(
  BuildContext context,
) => <BlocProvider<Cubit<Object>>>[
  BlocProvider<${featureName.capitalize()}Cubit>(create: (BuildContext context) => sl<${featureName.capitalize()}Cubit>()),
];

''');
}
