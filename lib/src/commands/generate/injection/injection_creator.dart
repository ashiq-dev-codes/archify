import 'package:archify/archify.dart';
import 'package:archify/src/extensions/string_extensions.dart';

void createInjectionFile(String featureName) {
  final packageName = getPackageName();
  final path = 'lib/features/$featureName/${featureName}_injection.dart';

  createFile(path, '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:$packageName/features/auth/data/data_source_impl/auth_data_source_impl.dart';
import 'package:$packageName/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:$packageName/features/auth/domain/data_source/auth_data_source.dart';
import 'package:$packageName/features/auth/domain/repo/auth_repo.dart';
import 'package:$packageName/features/auth/presentation/cubit/auth_cubit.dart';
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

void clearAuth(BuildContext context) {
  context.read<${featureName.capitalize()}Cubit>().clear;
}

List<BlocProvider<Cubit<Object>>> ${featureName}Blocs(
  BuildContext context,
) => <BlocProvider<Cubit<Object>>>[
  BlocProvider<${featureName.capitalize()}Cubit>(create: (BuildContext context) => sl<${featureName.capitalize()}Cubit>()),
];

''');
}
