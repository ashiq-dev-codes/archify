import 'package:archify/archify.dart';

void addDefaultPackages() {
  final packagesToAdd = {
    'dio': 'any',
    'get_it': 'any',
    'corextra': 'any',
    'equatable': 'any',
    'flutter_bloc': 'any',
    'device_preview': 'any',
    'shared_preferences': 'any',
  };

  addPackagesToPubspec(packagesToAdd);
}
