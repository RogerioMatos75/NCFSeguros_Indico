import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../services/auth_service.dart';
import 'package:get_it/get_it.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: _guardRoute,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminDashboard,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.indicationDetail,
      builder: (context, state) {
        final indicationId = state.params['id'] ?? '';
        return IndicationDetailScreen(indicationId: indicationId);
      },
    ),
  ],
);

Future<String?> _guardRoute(BuildContext context, GoRouterState state) async {
  final authService = GetIt.instance<AuthService>();
  final user = authService.currentUser;
  final publicRoutes = [AppRoutes.login, AppRoutes.signup];

  if (state.location == AppRoutes.splash) return null;
  if (user == null && !publicRoutes.contains(state.location))
    return AppRoutes.login;
  if (user != null && publicRoutes.contains(state.location))
    return AppRoutes.home;
  return null;
}
