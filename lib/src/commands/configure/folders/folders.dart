import 'package:archify/src/commands/configure/folders/core/api/api_creator.dart';
import 'package:archify/src/commands/configure/folders/core/config/config_creator.dart';
import 'package:archify/src/commands/configure/folders/core/model/model_creator.dart';
import 'package:archify/src/commands/configure/folders/main_creator.dart';
import 'package:archify/src/commands/configure/folders/shared/constant/constant_creator.dart';
import 'package:archify/src/commands/configure/folders/shared/path/path_creator.dart';
import 'package:archify/src/commands/configure/folders/shared/theme/theme_creator.dart';
import 'package:archify/src/commands/configure/folders/shared/utils/utils_creator.dart';
import 'package:archify/src/commands/configure/folders/shared/widget/widget_creator.dart';
import 'package:archify/src/utils/fs_utils.dart';

void createBaseFolders() {
  final folders = ['lib/feature', 'lib/core', 'lib/shared'];

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
