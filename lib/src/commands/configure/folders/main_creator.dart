import 'package:archify/src/utils/fs_utils.dart';

void createMainFiles() {
  final libPath = 'lib';
  final packageName = getPackageName();

  // 1️⃣ app.dart
  createFile('$libPath/app.dart', '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$packageName/shared/theme/main_theme.dart';
import 'package:$packageName/shared/utils/navigation/navigation_utils.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add your blocs here
        // Example:
        // ...authBlocs(context),
        // ...bookingBlocs(context),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        theme: MainTheme.mainThemeData(false),
        navigatorKey: NavigationUtils.navigatorKey,
        navigatorObservers: [NavigationUtils.routeObserver],

        // Add your screen here
        // Example:
        // Screen
        // home: const SplashScreen(),
      ),
    );
  }
}
''');

  // 2️⃣ injection_container.dart
  createFile('$libPath/injection_container.dart', '''
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

abstract class ServiceLocator {
  static Future<void> init() async {
    // Add your injections here
    // Example:
    // features
    // await initAuthInjection(sl);
    // await initBookingInjection(sl);
  }

  static void clear(BuildContext context) {
    // Add your clears here
    // Example:
    // clearAuth(context);
    // clearBooking(context);
  }
}
''');

  // 3️⃣ root.dart
  createFile('$libPath/root.dart', '''
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:$packageName/app.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: false,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: App(),
        );
      },
    );
  }
}
''');

  // 4️⃣ main.dart
  createFile('$libPath/main.dart', '''
import 'dart:async';

import 'package:corextra/corextra.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:$packageName/root.dart';

import '/injection_container.dart' as di;

// Late initializations
late SharedPreferences preferences;

void main() async {
  // Use runZonedGuarded to handle errors and ensure all bindings are initialized in the same zone
  runZonedGuarded(
    () async {
      // Ensure all bindings are properly initialized before using any plugins
      WidgetsFlutterBinding.ensureInitialized();
      // SentryWidgetsFlutterBinding.ensureInitialized();

      await _initializeServices(); // Initialize all required services

      /*

        await SentryFlutter.init((options) {
        options.dsn =
            kDebugMode
                ? ''
                : '';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        options.debug = kDebugMode;
        options.environment = AppConfig.server.name.toString();
      });

      */

      runApp(const AppRoot());
    },
    (error, stackTrace) async {
      // Log the error using a custom logger
      AppLogger.logError(error.toString());

      // Handle errors by recording them with Sentry
      // await Sentry.captureException(error, stackTrace: stackTrace);
    },
  );
}

// Initializes necessary services before running the app
Future<void> _initializeServices() async {
  await di.ServiceLocator.init();

  // Initialize Trackers
  // await SentryTracker.init();

  // Obtain an instance of SharedPreferences for persistent storage
  preferences = await SharedPreferences.getInstance();
}
''');
}
