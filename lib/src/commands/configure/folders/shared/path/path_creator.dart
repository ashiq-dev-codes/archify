import 'package:archify/src/utils/fs_utils.dart';

/// Creates the `lib/shared/path` folder and its files
void createPathFolder() {
  final path = 'lib/shared/path';

  createFolder(path);

  // 1️⃣ app_images.dart
  createFile('lib/shared/path/app_images.dart', '''
class AppImages {
  // Add your image paths here
  // Example:
  // static const String logo = "assets/images/logo.png";
}
''');

  // 2️⃣ app_svg.dart
  createFile('lib/shared/path/app_svg.dart', '''
class AppSvgs {
  // Add your svg paths here
  // Example:
  // static const String logo = "assets/svgs/logo.svg";
}
''');
}
