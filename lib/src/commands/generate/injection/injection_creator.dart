import 'dart:io';

import 'package:archify/src/extensions/string_extensions.dart';
import 'package:archify/src/utils/fs_utils.dart';

void createInjectionFile(String featureName) {
  final packageName = getPackageName();
  final path = 'lib/feature/$featureName/${featureName}_injection.dart';

  // 1️⃣ Create injection.dart
  createFile(path, '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:$packageName/feature/$featureName/data/data_source_impl/${featureName}_data_source_impl.dart';
import 'package:$packageName/feature/$featureName/data/repo_impl/${featureName}_repo_impl.dart';
import 'package:$packageName/feature/$featureName/domain/data_source/${featureName}_data_source.dart';
import 'package:$packageName/feature/$featureName/domain/repo/${featureName}_repo.dart';
import 'package:$packageName/feature/$featureName/presentation/cubit/${featureName}_cubit.dart';
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
      "import 'package:$packageName/feature/$featureName/${featureName}_injection.dart';";

  // ✅ Add import if missing
  if (!content.contains(importLine)) {
    final lastImportIndex = content.lastIndexOf('import');
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    content =
        '${content.substring(0, nextLineIndex + 1)}$importLine\n${content.substring(nextLineIndex + 1)}';
  }

  final pascal = featureName.toPascalCase();

  final initCall = '    await init${pascal}Injection(sl);';

  // ✅ Insert new init call inside `init()` before closing brace
  if (!content.contains(initCall)) {
    // Match the closing brace of the init() method
    final initRegex = RegExp(
      r'static\s+Future<void>\s+init\([^)]*\)\s*async\s*{([\s\S]*?)\n\s*}',
      multiLine: true,
    );

    final match = initRegex.firstMatch(content);
    if (match != null) {
      final methodBody = match.group(1)!;
      final updatedBody = '$methodBody\n$initCall';
      content = content.replaceFirst(methodBody, updatedBody);
    }
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
      "import 'package:$packageName/feature/$featureName/${featureName}_injection.dart';";

  // ✅ Add import if missing
  if (!content.contains(importLine)) {
    final lastImportIndex = content.lastIndexOf('import');
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    content =
        '${content.substring(0, nextLineIndex + 1)}$importLine\n${content.substring(nextLineIndex + 1)}';
  }

  final camel = featureName.toCamelCase();
  final blocLine = '          ...${camel}Blocs(context),';

  // ✅ Find the providers list and inject before closing bracket
  final providerRegex = RegExp(r'providers:\s*\[(.*?)\n\s*\],', dotAll: true);

  final match = providerRegex.firstMatch(content);
  if (match != null) {
    final listBody = match.group(1)!;
    if (!listBody.contains(blocLine)) {
      final updatedList = '$listBody\n$blocLine';
      content = content.replaceFirst(listBody, updatedList);
    }
  }

  file.writeAsStringSync(content);
  print('🧩 app.dart updated with $featureName blocs & import');
}
