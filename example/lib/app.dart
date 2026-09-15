import 'package:flutter/material.dart';

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

      // Add your theme here (e.g. MainTheme.mainThemeData from
      // shared/theme/main_theme.dart, if your structure generates one)

      // Add your screen here
    );
  }
}
