import 'dart:io';

import 'package:archify/src/extensions/string_extensions.dart';

/// Updates `lib/injection_container.dart` by adding the feature's init and
/// clear calls, only run when the feature's `feature_template` includes a
/// `feature_injection`-templated file.
void updateInjectionContainer({
  required String packageName,
  required String featureName,
  required String injectionImportPath,
}) {
  final file = File('lib/injection_container.dart');
  if (!file.existsSync()) {
    print('❌ injection_container.dart not found!');
    return;
  }

  String content = file.readAsStringSync();
  final importLine = "import 'package:$packageName/$injectionImportPath';";

  if (!content.contains(importLine)) {
    final lastImportIndex = content.lastIndexOf('import');
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    content =
        '${content.substring(0, nextLineIndex + 1)}$importLine\n${content.substring(nextLineIndex + 1)}';
  }

  final pascal = featureName.toPascalCase();
  final initCall = '    await init${pascal}Injection(sl);';

  if (!content.contains(initCall)) {
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

/// Updates `lib/app.dart`'s `MultiBlocProvider` with the feature's blocs.
void updateAppBlocs({
  required String packageName,
  required String featureName,
  required String injectionImportPath,
}) {
  final file = File('lib/app.dart');
  if (!file.existsSync()) {
    print('❌ app.dart not found!');
    return;
  }

  String content = file.readAsStringSync();
  final importLine = "import 'package:$packageName/$injectionImportPath';";

  if (!content.contains(importLine)) {
    final lastImportIndex = content.lastIndexOf('import');
    final nextLineIndex = content.indexOf('\n', lastImportIndex);
    content =
        '${content.substring(0, nextLineIndex + 1)}$importLine\n${content.substring(nextLineIndex + 1)}';
  }

  final camel = featureName.toCamelCase();
  final blocLine = '          ...${camel}Blocs(context),';

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
