import 'package:archify/archify.dart';

class ConfigureCommand {
  void run() {
    // 1️⃣ Create folders
    createBaseFolders();

    // 2️⃣ Update docs
    updateDocs();

    // 3️⃣ Update README
    updateReadme();

    // 4️⃣ Add packages
    addDefaultPackages();

    print('✅ Project configured successfully!');
  }
}
