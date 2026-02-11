import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/app_router.dart';
import 'package:to_do_app/providers/creation_provider.dart';
import 'package:to_do_app/providers/home_provider.dart';
import 'package:to_do_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/providers/update_provider.dart';
// import 'package:flutter/rendering.dart';

void main() {
  // debugPaintSizeEnabled = true;
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<CreationProvider>(
          create: (_) => CreationProvider(),
        ),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<UpdateProvider>(create: (_) => UpdateProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(loginProvider: context.read<LoginProvider>()).router;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Management Web',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
