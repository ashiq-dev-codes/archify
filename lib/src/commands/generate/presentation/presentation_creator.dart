import 'package:archify/src/extensions/string_extensions.dart';
import 'package:archify/src/utils/fs_utils.dart';

void createPresentationLayer(String featureName) {
  final packageName = getPackageName();
  final basePath = 'lib/features/$featureName/presentation';
  final folders = ['cubit', 'page', 'widget'];

  for (final folder in folders) {
    createFolder('$basePath/$folder');
  }

  // 1️⃣ Create cubit.dart
  createFile('$basePath/cubit/${featureName}_cubit.dart', '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/features/$featureName/domain/repo/${featureName}_repo.dart';

part '${featureName}_state.dart';

class ${featureName.capitalize()}Cubit extends Cubit<${featureName.capitalize()}State> {
  ${featureName.capitalize()}Cubit({required this.repo}) : super(${featureName.capitalize()}Initial());
  final ${featureName.capitalize()}Repo repo;

  void get clear {
    emit(${featureName.capitalize()}Initial());
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

abstract class ${featureName.capitalize()}State extends Equatable {
  const ${featureName.capitalize()}State();

  @override
  List<Object> get props => [];
}

class ${featureName.capitalize()}Initial extends ${featureName.capitalize()}State {}

class ${featureName.capitalize()}Loading extends ${featureName.capitalize()}State {}

class ${featureName.capitalize()}Success extends ${featureName.capitalize()}State {
  final Object object;
  const ${featureName.capitalize()}Success({required this.object});

  @override
  List<Object> get props => [object];
}

class ${featureName.capitalize()}Failure extends ${featureName.capitalize()}State {
  final Object error;
  const ${featureName.capitalize()}Failure({required this.error});

  @override
  List<Object> get props => [error];
}
''');

  // 3️⃣ Create page.dart
  createFile('$basePath/page/${featureName}_page.dart', '''
import 'package:flutter/material.dart';

class ${featureName.capitalize()}Screen extends StatelessWidget {
  const ${featureName.capitalize()}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Placeholder());
  }
}

''');
}
