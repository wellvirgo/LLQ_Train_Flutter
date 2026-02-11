import 'package:go_router/go_router.dart';
import 'package:to_do_app/providers/login_provider.dart';
import 'package:to_do_app/screens/creation_screen.dart';
import 'package:to_do_app/screens/home_screen.dart';
import 'package:to_do_app/screens/login_screen.dart';
import 'package:to_do_app/screens/update_screen.dart';

class AppRouter {
  final LoginProvider loginProvider;

  AppRouter({required this.loginProvider});

  late final router = GoRouter(
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/login'),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/create',
        builder: (context, state) => const CreationScreen(),
      ),
      GoRoute(
        path: '/edit/:id',
        builder: (context, state) {
          final String? idString = state.pathParameters['id'];
          final int id = int.tryParse(idString ?? '') ?? 0;
          return UpdateScreen(componentId: id);
        },
      ),
    ],
  );
}
