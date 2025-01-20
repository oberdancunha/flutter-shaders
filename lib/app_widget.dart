import 'package:flutter/material.dart';

import 'pages/main_menu_page.dart';
import 'pages/shader_page.dart';
import 'pages/shaders_menu_page.dart';

@immutable
final class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Color(0xFF47494b),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF47494b),
          ),
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF47494b),
          ),
        ),
        routes: {
          '/': (_) => MainMenuPage(),
          '/shaders': (_) => ShadersMenuPage(),
          '/shader': (_) => ShaderPage(),
        },
      );
}
