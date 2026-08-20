/// Built-in content generators for `archify.yaml` file nodes.
///
/// A file node with `template: <key>` gets the matching boilerplate below,
/// rendered with the project's package name. An unrecognized key (or no
/// `template` key at all) resolves to `null`, and the caller creates an
/// empty file instead.
String? renderBaseTemplate(String key, String packageName) {
  switch (key) {
    case 'main':
      return _main(packageName);
    case 'app':
      return _app(packageName);
    case 'root':
      return _root(packageName);
    case 'injection_container':
      return _injectionContainer();
    case 'app_config':
      return _appConfig();
    case 'dio_client':
      return _dioClient(packageName);
    case 'constant':
      return _constant();
    case 'path_images':
      return _pathImages();
    case 'path_svg':
      return _pathSvg();
    case 'theme_colors':
      return _themeColors();
    case 'theme_themes':
      return _themeThemes();
    case 'theme_main':
      return _themeMain();
    case 'dio_interceptor':
      return _dioInterceptor(packageName);
    case 'navigation_utils':
      return _navigationUtils(packageName);
    case 'navigation':
      return _navigation();
    case 'route_tracker':
      return _routeTracker();
    case 'app_storage':
      return _appStorage(packageName);
    case 'local_storage':
      return _localStorage();
    case 'custom_snack_bar':
      return _customSnackBar();
    case 'loading_dialog':
      return _loadingDialog();
    default:
      return null;
  }
}

String _app(String packageName) => '''
import 'package:flutter/material.dart';
import 'package:$packageName/shared/theme/main_theme.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    // Wrap in MultiBlocProvider (flutter_bloc) if you use Bloc/Cubit
    return MaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: MainTheme.mainThemeData(false),

      // Add your screen here
    );
  }
}
''';

String _injectionContainer() => '''
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

abstract class ServiceLocator {
  static Future<void> init() async {
    // Add your feature injections here
  }

  static void clear(BuildContext context) {
    // Add your feature clears here
  }
}
''';

String _root(String packageName) => '''
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
    // Wrap in DevicePreview (device_preview) if you want it
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: App(),
    );
  }
}
''';

String _main(String packageName) => '''
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:$packageName/root.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await _initializeServices();

      runApp(const AppRoot());
    },
    (error, stackTrace) async {
      // Add your error logging here
    },
  );
}

// Initializes required services before running the app
Future<void> _initializeServices() async {
  // Add your service/DI initialization here
}
''';

String _appConfig() => '''
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
''';

String _dioClient(String packageName) => '''
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
''';

String _constant() => '''
import 'package:flutter/material.dart';

// Constant Empty Height
const kHeight5 = SizedBox(height: 5);
const kHeight10 = SizedBox(height: 10);
const kHeight15 = SizedBox(height: 15);
const kHeight20 = SizedBox(height: 20);
const kHeight25 = SizedBox(height: 25);
const kHeight30 = SizedBox(height: 30);
const kHeight35 = SizedBox(height: 35);
const kHeight40 = SizedBox(height: 40);
const kHeight45 = SizedBox(height: 45);
const kHeight50 = SizedBox(height: 50);
const kHeight55 = SizedBox(height: 55);
const kHeight60 = SizedBox(height: 60);
const kHeight65 = SizedBox(height: 65);
const kHeight70 = SizedBox(height: 70);

// Constant Empty Width
const kWidth5 = SizedBox(width: 5);
const kWidth10 = SizedBox(width: 10);
const kWidth15 = SizedBox(width: 15);
const kWidth20 = SizedBox(width: 20);
const kWidth25 = SizedBox(width: 25);
const kWidth30 = SizedBox(width: 30);
const kWidth35 = SizedBox(width: 35);
const kWidth40 = SizedBox(width: 40);
const kWidth45 = SizedBox(width: 45);
const kWidth50 = SizedBox(width: 50);
const kWidth55 = SizedBox(width: 55);
const kWidth60 = SizedBox(width: 60);
const kWidth65 = SizedBox(width: 65);
const kWidth70 = SizedBox(width: 70);

/* <------ Margin or Padding ------> */

// Constant All Margin or Padding Values
const kAll5 = EdgeInsets.all(5);
const kAll10 = EdgeInsets.all(10);
const kAll15 = EdgeInsets.all(15);
const kAll20 = EdgeInsets.all(20);
const kAll25 = EdgeInsets.all(25);
const kAll30 = EdgeInsets.all(30);
const kAll35 = EdgeInsets.all(35);
const kAll40 = EdgeInsets.all(40);
const kAll45 = EdgeInsets.all(45);
const kAll50 = EdgeInsets.all(50);
const kAll55 = EdgeInsets.all(55);
const kAll60 = EdgeInsets.all(60);
const kAll65 = EdgeInsets.all(65);
const kAll70 = EdgeInsets.all(70);

// Constant Vertical Margin or Padding Values
const kVertical5 = EdgeInsets.symmetric(vertical: 5);
const kVertical10 = EdgeInsets.symmetric(vertical: 10);
const kVertical15 = EdgeInsets.symmetric(vertical: 15);
const kVertical20 = EdgeInsets.symmetric(vertical: 20);
const kVertical25 = EdgeInsets.symmetric(vertical: 25);
const kVertical30 = EdgeInsets.symmetric(vertical: 30);
const kVertical35 = EdgeInsets.symmetric(vertical: 35);
const kVertical40 = EdgeInsets.symmetric(vertical: 40);
const kVertical45 = EdgeInsets.symmetric(vertical: 45);
const kVertical50 = EdgeInsets.symmetric(vertical: 50);
const kVertical55 = EdgeInsets.symmetric(vertical: 55);
const kVertical60 = EdgeInsets.symmetric(vertical: 60);
const kVertical65 = EdgeInsets.symmetric(vertical: 65);
const kVertical70 = EdgeInsets.symmetric(vertical: 70);

// Constant Horizontal Margin or Padding Values
const kHorizontal5 = EdgeInsets.symmetric(horizontal: 5);
const kHorizontal10 = EdgeInsets.symmetric(horizontal: 10);
const kHorizontal15 = EdgeInsets.symmetric(horizontal: 15);
const kHorizontal20 = EdgeInsets.symmetric(horizontal: 20);
const kHorizontal25 = EdgeInsets.symmetric(horizontal: 25);
const kHorizontal30 = EdgeInsets.symmetric(horizontal: 30);
const kHorizontal35 = EdgeInsets.symmetric(horizontal: 35);
const kHorizontal40 = EdgeInsets.symmetric(horizontal: 40);
const kHorizontal45 = EdgeInsets.symmetric(horizontal: 45);
const kHorizontal50 = EdgeInsets.symmetric(horizontal: 50);
const kHorizontal55 = EdgeInsets.symmetric(horizontal: 55);
const kHorizontal60 = EdgeInsets.symmetric(horizontal: 60);
const kHorizontal65 = EdgeInsets.symmetric(horizontal: 65);
const kHorizontal70 = EdgeInsets.symmetric(horizontal: 70);
''';

String _pathImages() => '''
class AppImages {
  // Add your image paths here
}
''';

String _pathSvg() => '''
class AppSvgs {
  // Add your svg paths here
}
''';

String _themeColors() => '''
import 'package:flutter/material.dart';

class AppColors {
  // Base Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  // Add your base colors here

  // Accent Colors
  static const Color accent100 = Color(0xFFFCFCFD);
  static const Color accent200 = Color(0xFFF8F9FC);
  static const Color accent300 = Color(0xFFEAECF5);
  static const Color accent400 = Color(0xFFD5D9EB);
  static const Color accent500 = Color(0xFFB3B8DB);
  static const Color accent600 = Color(0xFF717BBC);
  static const Color accent700 = Color(0xFF4E5BA6);
  static const Color accent800 = Color(0xFF3E4784);
  static const Color accent900 = Color(0xFF0D0F1C);

  // Gray Colors
  static const Color gray100 = Color(0xFFF9FAFB);
  static const Color gray200 = Color(0xFFE2E8F0);
  static const Color gray300 = Color(0xFFEAECF0);
  static const Color gray400 = Color(0xFFD0D5DD);
  static const Color gray450 = Color(0xFFCBD5E1);
  static const Color gray500 = Color(0xFF98A2B3);
  static const Color gray600 = Color(0xFF667085);
  static const Color gray700 = Color(0xFF475467);
  static const Color gray800 = Color(0xFF344054);
  static const Color gray900 = Color(0xFF101828);
  static const Color gray950 = Color(0xFF0C111D);

  // Error Colors
  static const Color error100 = Color(0xFFFFFBFA);
  static const Color error200 = Color(0xFFFEF3F2);
  static const Color error300 = Color(0xFFFEE4E2);
  static const Color error400 = Color(0xFFFECDCA);
  static const Color error500 = Color(0xFFF97066);
  static const Color error600 = Color(0xFFF04438);
  static const Color error700 = Color(0xFFD92D20);
  static const Color error800 = Color(0xFF912018);
  static const Color error900 = Color(0xFF7A271A);
  static const Color error950 = Color(0xFF55160C);

  // Success Colors
  static const Color success100 = Color(0xFFF6FEF9);
  static const Color success200 = Color(0xFFECFDF3);
  static const Color success300 = Color(0xFFDCFAE6);
  static const Color success400 = Color(0xFFABEFC6);
  static const Color success500 = Color(0xFF47CD89);
  static const Color success600 = Color(0xFF17B26A);
  static const Color success700 = Color(0xFF079455);
  static const Color success800 = Color(0xFF067647);
  static const Color success900 = Color(0xFF074D31);
  static const Color success950 = Color(0xFF053321);

  // Warning Colors
  static const Color warning100 = Color(0xFFFFFCF5);
  static const Color warning200 = Color(0xFFFEF0C7);
  static const Color warning300 = Color(0xFFFEC84B);
  static const Color warning400 = Color(0xFFFDB022);
  static const Color warning500 = Color(0xFFF79009);
  static const Color warning600 = Color(0xFFDC6803);
  static const Color warning700 = Color(0xFFB54708);
  static const Color warning800 = Color(0xFF93370D);
  static const Color warning900 = Color(0xFF7A2E0E);
  static const Color warning950 = Color(0xFF4E1D09);

  // Add your other colors here
}
''';

String _themeThemes() => '''
class AppThemes {
  // Add your app themes here
}
''';

String _themeMain() => '''
import 'package:flutter/material.dart';

class MainTheme {
  static ThemeData mainThemeData(bool isDarkMode) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.grey.withValues(alpha: 0.11),
      highlightColor: Colors.grey.withValues(alpha: 0.11),

      // Add your main theme here
    );
  }
}
''';

String _dioInterceptor(String packageName) => '''
import 'package:corextra/corextra.dart';
import 'package:dio/dio.dart';
import 'package:$packageName/core/config/config.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.logRequest(
      options.baseUrl,
      options.path,
      data: options.data,
      query: options.queryParameters,
    );

    if (AppConfig.token != null) {
      debugLog('Token: \${AppConfig.token!}');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    AppLogger.logResponse(response);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.logDioError(err);

    super.onError(err, handler);
  }
}

extension DioMessage on DioException {
  String get dioMessage =>
      (error == null
          ? 'An unexpected error occurred. Please contact the admin for assistance'
          : (error.toString()));
}
''';

String _navigationUtils(String packageName) => '''
import 'package:flutter/material.dart';
import 'package:$packageName/shared/utils/route/route_tracker.dart';

class NavigationUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteTracker routeObserver = RouteTracker();
}
''';

String _navigation() => '''
import 'package:flutter/material.dart';

/// A utility function to navigate to a screen using a [MaterialPageRoute].
Future<T?> push<T>(
  BuildContext context,
  Widget screen, {
  Route<T>? customRoute,
  bool replace = false,
  bool removeUntil = false,
  bool Function(Route<dynamic> route)? predicate,
}) {
  final navigator = Navigator.of(context);
  final route =
      customRoute ??
      MaterialPageRoute(builder: (context) => screen);

  if (removeUntil) {
    return navigator.pushAndRemoveUntil(route, predicate ?? (route) => false);
  } else if (replace) {
    return navigator.pushReplacement(route);
  } else {
    return navigator.push(route);
  }
}

Future<T?> pushNamed<T>(
  BuildContext context,
  String routeName, {
  bool replace = false,
  bool removeUntil = false,
  bool Function(Route<dynamic> route)? predicate,
}) {
  final navigator = Navigator.of(context);

  if (removeUntil) {
    return navigator.pushNamedAndRemoveUntil(
      routeName,
      predicate ?? (route) => false,
    );
  } else if (replace) {
    return navigator.pushReplacementNamed(routeName);
  } else {
    return navigator.pushNamed(routeName);
  }
}

/// A utility function to pop the current screen from the navigation stack.
void pop<T extends Object?>(BuildContext context, {T? result}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop(result);
  }
}

/// A utility function to pop the current screen from the navigation stack.
void popUntil(
  BuildContext context, {
  bool Function(Route<dynamic> route)? predicate,
}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).popUntil(predicate ?? (route) => false);
  }
}

///////////* <------ Custom Page Route Builder ------> *///////////

/// A utility function to create an opaque page route that allows the previous screen to be visible in the background.
/// This is useful for scenarios where you want to display a page with a non-blocking background, such as a dialog or bottom sheet.
PageRouteBuilder opaquePage(Widget page) {
  return PageRouteBuilder(
    opaque: false,
    pageBuilder: (BuildContext context, _, __) => page,
  );
}

/// A custom transition for bottom sheet navigation with slide-in effect.
PageRouteBuilder<T> bottomSheetRoute<T>(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => screen,
    transitionsBuilder: (_, animation, __, child) {
      final tween = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      );
      final offsetAnimation = animation.drive(
        tween.chain(CurveTween(curve: Curves.easeInOut)),
      );
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
''';

String _routeTracker() => '''
import 'package:flutter/material.dart';

class RouteTracker extends RouteObserver<PageRoute<dynamic>> {
  static String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    _update(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _update(previousRoute);
    super.didPop(route, previousRoute);
  }

  void _update(Route? route) {
    if (route is PageRoute) {
      currentRoute = route.settings.name;
    }
  }
}
''';

String _appStorage(String packageName) => '''
import 'package:corextra/corextra.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:$packageName/shared/utils/storage/local_storage.dart';

class AppStorage {
  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  static Future<bool> get clearStorage async => (await _prefs).clear();

  // Auth token storage
  static Future<bool> setToken(String? value) async {
    return !isStringEmpty(value)
        ? (await _prefs).setString(LocalStorage.token, value ?? '')
        : removeToken;
  }

  static Future<String?> get getToken async =>
      (await _prefs).getString(LocalStorage.token);

  static Future<bool> get removeToken async =>
      (await _prefs).remove(LocalStorage.token);
}
''';

String _localStorage() => '''
class LocalStorage {
  static const token = 'token';
}
''';

String _customSnackBar() => '''
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
''';

String _loadingDialog() => '''
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
''';
