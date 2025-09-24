import 'package:archify/archify.dart';
import 'package:archify/src/extensions/string_extensions.dart';

void createDataLayer(String featureName) {
  final packageName = getPackageName();
  final basePath = 'lib/features/$featureName/data';
  final folders = ['data_source_impl', 'repo_impl'];

  for (final folder in folders) {
    createFolder('$basePath/$folder');
  }

  // 1️⃣ Create data_source_impl.dart
  createFile(
    '$basePath/data_source_impl/${featureName}_data_source_impl.dart',
    '''
import 'package:$packageName/features/$featureName/domain/data_source/${featureName}_data_source.dart';

    // Add your apis here
    // Example:
    // const String loginApi = 'login';

class ${featureName.capitalize()}DataSourceImpl implements ${featureName.capitalize()}DataSource{
    // Add your data source implements here
    // Example:
    /*
      @override
      Future<bool> login() async {
        try {
          Response response = await api.post(url: loginApi);

          return (response.statusCode ?? 0) ~/ 100 == 2;
        } catch (e) {
          rethrow;
        }
      }
    */
}
''',
  );

  // 2️⃣ Create repo_impl.dart
  createFile('$basePath/repo_impl/${featureName}_repo_impl.dart', '''
import 'package:$packageName/features/$featureName/domain/data_source/${featureName}_data_source.dart';
import 'package:$packageName/features/$featureName/domain/repo/${featureName}_repo.dart';

class ${featureName.capitalize()}RepoImpl implements ${featureName.capitalize()}Repo {
  ${featureName.capitalize()}RepoImpl({required this.remote});
  final ${featureName.capitalize()}DataSource remote;

  // Add your repo implements here
  // Example:
  /*
    @override
    Future<bool> login() async {
      try {
        return await remote.login();
      } catch (e) {
        rethrow;
      }
    }
  */
}
''');
}
