import 'package:archify/src/utils/fs_utils.dart';

void createWidgetsFolder() {
  final widgetPath = 'lib/shared/widget';

  createFolder(widgetPath);

  // 1️⃣ Create global subfolder
  final globalPath = '$widgetPath/global';
  createFolder(globalPath);

  // 2️⃣ Create custom_snack_bar.dart inside global folder
  createFile('$globalPath/custom_snack_bar.dart', '''
import 'package:flutter/material.dart';

class CustomSnackBar {
  static void show(
    BuildContext context,
    String title, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 1,
        duration: duration,
        content: Text(title),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static void message(BuildContext context, String title) {
    show(context, title, duration: const Duration(seconds: 5));
  }

  static void success(BuildContext context, String title) {
    show(context, title, backgroundColor: Colors.green);
  }

  static void error(BuildContext context, String title) {
    show(
      context,
      title,
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 7),
    );
  }
}
''');

  // 3️⃣ Create loading subfolder
  final loadingPath = '$widgetPath/loading';
  createFolder(loadingPath);

  // 4️⃣ Create loading_dialog.dart inside loading folder
  createFile('$loadingPath/loading_dialog.dart', '''
import 'package:flutter/material.dart';

class LoadingDialog {
  static Future<T> show<T>(BuildContext context, Future<T> future) async {
    // Show the loading dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (c) => Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(c).size.width * 0.3,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 15),
                  Text('Loading...'),
                ],
              ),
            ),
          ),
    );

    try {
      return await future;
    } catch (e) {
      rethrow;
    } finally {
      // Dismiss the dialog using the context of the dialog itself
      if (Navigator.canPop(context)) Navigator.pop(context);
    }
  }
}
''');
}
