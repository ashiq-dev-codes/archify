import 'package:archify/src/utils/fs_utils.dart';

/// Creates the config folder and then the necessary files inside it
void createConfigFolder() {
  final configPath = 'lib/core/config';

  createFolder(configPath);

  // After folder creation, create files
  _createConfigFiles();
}

/// Creates all files inside config folder
void _createConfigFiles() {
  // 1️⃣ config.dart
  createFile('lib/core/config/config.dart', '''
enum Build { e2e, testing, production }

class AppConfig {
  static String? token;
  static const String _env = String.fromEnvironment(
    'BUILD',
    defaultValue: 'production',
  );

  static Build get server {
    switch (_env) {
      case 'e2e':
        return Build.e2e;

      case 'testing':
        return Build.testing;

      case 'production':
      default:
        return Build.production;
    }
  }

  static String get baseUrl {
    switch (server) {
      case Build.e2e:
        return "https://api.example.com";

      case Build.testing:
        return "https://api.example.com";

      case Build.production:
        return "https://api.example.com";
    }
  }
}
''');

  // 2️⃣ dio.dart
  final packageName = getPackageName();
  createFile('lib/core/config/dio.dart', '''
import 'package:dio/dio.dart';
import 'package:$packageName/core/config/config.dart';
import 'package:$packageName/shared/utils/dio/dio_interceptors.dart';

/// Configures and returns a Dio instance with base options and interceptors.
Dio get api {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      sendTimeout: const Duration(milliseconds: 100000),
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    ),
  )..interceptors.addAll([AppInterceptor()]);
}
''');
}
