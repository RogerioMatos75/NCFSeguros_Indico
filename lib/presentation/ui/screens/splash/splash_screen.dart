import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart'; // Adicionado para usar AppRoutes

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simula um delay para mostrar a tela de splash.
    // O redirecionamento real será tratado pelo GoRouter com base no estado de autenticação.
    await Future.delayed(const Duration(seconds: 2));
    
    // Após o delay, o GoRouter já deverá ter feito o redirecionamento necessário
    // com base na lógica em app_router.dart. Nenhuma navegação explícita é necessária aqui.
    // Se o usuário não estiver autenticado, será redirecionado para /login.
    // Se estiver autenticado, será redirecionado para /home.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}