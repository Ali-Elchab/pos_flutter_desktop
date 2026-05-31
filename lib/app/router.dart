import 'package:go_router/go_router.dart';
import 'package:pos_flutter_desktop/layout/pos_shell_screen.dart';

abstract final class AppRoutes {
  static const pos = '/';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.pos,
  routes: [
    GoRoute(
      path: AppRoutes.pos,
      builder: (context, state) => const PosShellScreen(),
    ),
  ],
);
