import 'dart:io';

import 'package:archify/src/extensions/string_extensions.dart';
import 'package:archify/src/utils/fs_utils.dart';

void createInjectionFile(String featureName) {
  final packageName = getPackageName();
  final path = 'lib/features/$featureName/${featureName}_injection.dart';

  // 1️⃣ Create injection.dart
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

  // 2️⃣ Update injection_container.dart
  _updateInjectionContainer(packageName, featureName);

  // 3️⃣ Update App.dart MultiBlocProvider
  _updateAppBlocs(packageName, featureName);
}

/// Updates injection_container.dart by adding init and clear calls
void _updateInjectionContainer(String packageName, String featureName) {
  final file = File('lib/injection_container.dart');
  if (!file.existsSync()) {
    print('❌ injection_container.dart not found!');
    return;
  }

  String content = file.readAsStringSync();
  final importLine =
      "import 'package:$packageName/features/$featureName/${featureName}_injection.dart';";

  // Add import at the top if not present
  if (!content.contains(importLine)) {
    // Insert after the last existing import
    final lastImportIndex = content.lastIndexOf('import');
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    content =
        '${content.substring(0, nextLineIndex + 1)}$importLine\n${content.substring(nextLineIndex + 1)}';
  }

  // Add init and clear calls
  final initLine = '// Add your injections here';
  final clearLine = '// Add your clears here';

  final initCall = '    await init${featureName.capitalize()}Injection(sl);';
  final clearCall = '    clear${featureName.capitalize()}(context);';

  if (!content.contains(initCall)) {
    content = content.replaceFirst(initLine, '$initLine\n$initCall');
  }

  if (!content.contains(clearCall)) {
    content = content.replaceFirst(clearLine, '$clearLine\n$clearCall');
  }

  file.writeAsStringSync(content);
  print(
    '🧩 injection_container.dart updated with $featureName injections & import',
  );
}

/// Updates App.dart MultiBlocProvider with feature blocs
void _updateAppBlocs(String packageName, String featureName) {
  final file = File('lib/app.dart');
  if (!file.existsSync()) {
    print('❌ app.dart not found!');
    return;
  }

  String content = file.readAsStringSync();
  final importLine =
      "import 'package:$packageName/features/$featureName/${featureName}_injection.dart';";

  // Add import at the top if not present
  if (!content.contains(importLine)) {
    final lastImportIndex = content.lastIndexOf('import');
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    content =
        '${content.substring(0, nextLineIndex + 1)}$importLine\n${content.substring(nextLineIndex + 1)}';
  }

  // Add bloc lines
  final marker = '// Add your blocs here';
  final blocLine = '        ...${featureName}Blocs(context),';

  if (!content.contains(blocLine)) {
    content = content.replaceFirst(marker, '$marker\n$blocLine');
  }

  file.writeAsStringSync(content);
  print('🧩 app.dart updated with $featureName blocs & import');
}
