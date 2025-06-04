import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_routes.dart';
import '../../../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/auth/new_modern_login_screen.dart'; // Adicionar import da LoginScreen 
import '../screens/splash/splash_screen.dart';
import '../screens/new_indication_screen.dart';
import '../../viewmodels/indication_form_view_model.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash, // Modificado para a splash screen original
  redirect: (context, state) {
    final authService = GetIt.instance<AuthService>();
    final isAuthenticated = authService.currentUser != null;
    // Usar state.uri.path para comparar caminhos de rota de forma mais robusta,
    // pois state.uri.toString() pode incluir query parameters.
    final String currentRoutePath = state.uri.path;
    final bool isOnLoginRoute = currentRoutePath == AppRoutes.login;
    final bool isOnSplashRoute = currentRoutePath == AppRoutes.splash;

    // Se o usuário está autenticado
    if (isAuthenticated) {
      // Se autenticado e tentando acessar a tela de login ou splash, redireciona para home.
      if (isOnLoginRoute || isOnSplashRoute) {
        return AppRoutes.home;
      }
      // Se autenticado e tentando acessar qualquer outra rota, permite.
      return null;
    }
    // Se o usuário NÃO está autenticado
    else {
      // Se não autenticado e já está na tela de login ou splash, permite (fica lá).
      if (isOnLoginRoute || isOnSplashRoute) {
        return null;
      }
      // Se não autenticado e tentando acessar qualquer outra rota, redireciona para login.
      return AppRoutes.login;
    }
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login, // Adicionar rota para LoginScreen
      builder: (context, state) => const NewModernLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.newIndication,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => GetIt.instance<IndicationFormViewModel>(),
        child: const NewIndicationScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
      // Adicionar redirect para login se não autenticado pode ser feito aqui também,
      // dependendo da estratégia de guarda de rotas.
    ),
    // ... outras rotas ...
    // Exemplo:
    // GoRoute(
    //   path: AppRoutes.login,
    //   builder: (context, state) => LoginScreen(),
    // ),
    // GoRoute(
    //   path: AppRoutes.profile,
    //   builder: (context, state) => ProfileScreen(),
    // ),
  ],
  // Adicionar errorBuilder para lidar com rotas não encontradas
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Página não encontrada: ${state.error}'),
    ),
  ),
);
