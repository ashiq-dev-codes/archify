import 'package:archify/archify.dart';

void createUtilsFolder() {
  final utilsPath = 'lib/shared/utils';

  createFolder(utilsPath);

  // 1️⃣ Create dio subfolder
  final dioPath = '$utilsPath/dio';
  final packageName = getPackageName();
  createFolder(dioPath);

  // 2️⃣ Create dio_interceptors.dart inside dio folder
  createFile('$dioPath/dio_interceptors.dart', '''
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
      // Log request token
      debugLog('Token: \${AppConfig.token!}');
    }

    // Log request details to Sentry
    // SentryTracker.recordRequest(options);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Log Response Data
    AppLogger.logResponse(response);

    // Log response details to Sentry
    // SentryTracker.recordResponse(response);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Log the error using a custom logger
    AppLogger.logDioError(err);

    // Reports the error to Sentry
    // Sentry.captureException(err);

    super.onError(err, handler);
  }
}

extension DioMessage on DioException {
  String get dioMessage =>
      (error == null
          ? 'An unexpected error occurred. Please contact the admin for assistance'
          : (error.toString()));
}
''');

  // 3️⃣ Create navigation subfolder
  final navigationPath = '$utilsPath/navigation';
  createFolder(navigationPath);

  // 4️⃣ Create navigation_utils.dart inside navigation folder
  createFile('$navigationPath/navigation_utils.dart', '''
import 'package:flutter/material.dart';
import 'package:$packageName/shared/utils/route/route_tracker.dart';

class NavigationUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final RouteTracker routeObserver = RouteTracker();
}
''');

  // 5️⃣ Create navigation.dart inside navigation folder
  createFile('$navigationPath/navigation.dart', '''
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
  // final screenName = RouteNames.getRouteNameForScreen(screen);
  final route =
      customRoute ??
      MaterialPageRoute(
        builder: (context) => screen,
        // settings: RouteSettings(name: screenName),
      );

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
''');

  // 6️⃣ Create route subfolder
  final routePath = '$utilsPath/route';
  createFolder(routePath);

  // 7️⃣ Create route_tracker.dart inside storage folder
  createFile('$routePath/route_tracker.dart', '''
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
''');

  // 8️⃣ Create storage subfolder
  final storagePath = '$utilsPath/storage';
  createFolder(storagePath);

  // 9️⃣ Create app_storage.dart inside storage folder
  createFile('$storagePath/app_storage.dart', '''
import 'package:corextra/corextra.dart';
import 'package:$packageName/main.dart';
import 'package:$packageName/shared/utils/storage/local_storage.dart';

class AppStorage {
  static Future<bool> get clearStorage async => await preferences.clear();

  /*  Start - Auth Token Storage Management */
  static Future<bool> setToken(String? value) async {
    return !isStringEmpty(value)
        ? await preferences.setString(LocalStorage.token, value ?? '')
        : removeToken;
  }

  static String? get getToken => preferences.getString(LocalStorage.token);

  static Future<bool> get removeToken async =>
      await preferences.remove(LocalStorage.token);

  /*  End - Auth Token Storage Management */
}
''');

  // 1️⃣0️⃣ Create local_storage.dart inside storage folder
  createFile('$storagePath/local_storage.dart', '''
class LocalStorage {
  static const token = 'token';
}
''');
}
