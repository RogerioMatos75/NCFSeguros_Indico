import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_routes.dart';
import '../../../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/new_indication_screen.dart';
import '../../viewmodels/indication_form_view_model.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) {
    final authService = GetIt.instance<AuthService>();
    final isAuthenticated = authService.currentUser != null;
    final isOnLoginPage = state.uri.toString() == AppRoutes.login;
    final isOnSplashPage = state.uri.toString() == AppRoutes.splash;

    // Não redirecionar na splash screen
    if (isOnSplashPage) return null;

    // Se não estiver autenticado e não estiver na página de login
    if (!isAuthenticated && !isOnLoginPage) {
      return AppRoutes.login;
    }

    // Se estiver autenticado e estiver na página de login
    if (isAuthenticated && isOnLoginPage) {
      return AppRoutes.home;
    }

    return null;
  },
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
      path: AppRoutes.newIndication,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => GetIt.instance<IndicationFormViewModel>(),
        child: const NewIndicationScreen(),
      ),
    ),
  ],
);
