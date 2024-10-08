import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saas_crm/module/index.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final _router = AppRouter.init();

  Brightness brightness = Brightness.light;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Poscrisma',
      theme: ThemeData(
        // Use a fonte padrão do Cupertino
        fontFamily: '.SF Pro Text',

        // Customize o tema Material para se parecer mais com o Cupertino
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,

        // Customize os Text Themes
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 17),
          bodyMedium: TextStyle(fontSize: 15),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        // Customize os AppBar para se parecerem com a NavigationBar do Cupertino
        appBarTheme: const AppBarTheme(
          backgroundColor: CupertinoColors.systemBackground,
          foregroundColor: CupertinoColors.label,
          elevation: 0,
        ),
      ),
      routerConfig: _router,
    );
  }
}
