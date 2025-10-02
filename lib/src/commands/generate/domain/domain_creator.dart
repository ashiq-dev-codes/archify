import 'package:archify/src/extensions/string_extensions.dart';
import 'package:archify/src/utils/fs_utils.dart';

void createDomainLayer(String featureName) {
  final basePath = 'lib/feature/$featureName/domain';
  final folders = ['data_source', 'repo'];

  for (final folder in folders) {
    createFolder('$basePath/$folder');
  }

  // 1️⃣ Create _data_source.dart
  createFile('$basePath/data_source/${featureName}_data_source.dart', '''
abstract class ${featureName.capitalize()}DataSource {
  // Add your data source here
  // Example:
  // Future<bool> login();
}
''');

  // 2️⃣ Create _repo.dart
  createFile('$basePath/repo/${featureName}_repo.dart', '''
abstract class ${featureName.capitalize()}Repo {
  // Add your repo here
  // Example:
  // Future<bool> sendOTP();
}
''');
}
