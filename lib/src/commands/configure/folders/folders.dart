import 'package:archify/archify.dart';

void createBaseFolders() {
  final folders = ['lib/features', 'lib/core', 'lib/shared'];

  for (final folder in folders) {
    createFolder(folder);
  }

  _createMain();
  _createCoreFolders();
  _createSharedFolders();
}

/// Master method to create all core folders and files
void _createMain() {
  createMainFiles();
}

/// Master method to create all core folders and files
void _createCoreFolders() {
  createConfigFolder();
  createApiFolder();
  createModelFolder();
}

/// Master method to create all shared folders and files
void _createSharedFolders() {
  createConstantFolder();
  createPathFolder();
  createThemeFolder();
  createUtilsFolder();
  createWidgetsFolder();
}
