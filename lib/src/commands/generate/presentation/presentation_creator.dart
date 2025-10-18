import 'package:archify/src/extensions/string_extensions.dart';
import 'package:archify/src/utils/fs_utils.dart';

void createPresentationLayer(String featureName) {
  final packageName = getPackageName();
  final basePath = 'lib/feature/$featureName/presentation';
  final folders = ['cubit', 'page', 'widget'];

  for (final folder in folders) {
    createFolder('$basePath/$folder');
  }

  // 1️⃣ Create cubit.dart
  createFile('$basePath/cubit/${featureName}_cubit.dart', '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/feature/$featureName/domain/repo/${featureName}_repo.dart';

part '${featureName}_state.dart';

class ${featureName.toPascalCase()}Cubit extends Cubit<${featureName.toPascalCase()}State> {
  ${featureName.toPascalCase()}Cubit({required this.repo}) : super(${featureName.toPascalCase()}Initial());
  final ${featureName.toPascalCase()}Repo repo;

  void get clear {
    emit(${featureName.toPascalCase()}Initial());
  }

  // Add your bloc functions here
  // Example:
  /*
  Future<bool> login() async {
    return await repo.login();
  }
  */
}
''');

  // 2️⃣ Create state.dart
  createFile('$basePath/cubit/${featureName}_state.dart', '''
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
''');

  // 3️⃣ Create page.dart
  createFile('$basePath/page/${featureName}_page.dart', '''
import 'package:flutter/material.dart';

class ${featureName.toPascalCase()}Screen extends StatelessWidget {
  const ${featureName.toPascalCase()}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Placeholder());
  }
}

''');
}
