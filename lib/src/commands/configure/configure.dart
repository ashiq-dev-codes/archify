import 'package:archify/archify.dart';

class ConfigureCommand {
  void run() {
    // 1️⃣ Create folders
    createBaseFolders();

    // 2️⃣ Update README
    updateReadme();

    // 3️⃣ Add packages
    addDefaultPackages();

    print('✅ Project configured successfully!');
  }
}
