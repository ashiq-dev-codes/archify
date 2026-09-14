import 'package:flutter/material.dart';
import 'package:example/feature/auth/presentation/page/auth_page.dart';
import 'package:example/shared/theme/main_theme.dart';

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
      debugShowCheckedModeBanner: false,
      theme: MainTheme.mainThemeData(false),

      // dart run archify generate <feature> to add more screens
      home: const AuthScreen(),
    );
  }
}
