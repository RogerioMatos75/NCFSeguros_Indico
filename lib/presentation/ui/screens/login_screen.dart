import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_routes.dart';
import '../../viewmodels/auth_view_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authViewModel = context.read<AuthViewModel>();
      await authViewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        if (authViewModel.error == null && authViewModel.isAuthenticated) {
          context.go(AppRoutes.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authViewModel.error ?? 'Falha no login. Tente novamente.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png', // Certifique-se que este asset existe
                  height: 150,
                ),
                const SizedBox(height: 48.0),
                CustomTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                if (authViewModel.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      authViewModel.error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                CustomButton(
                  text: 'Entrar',
                  onPressed: authViewModel.isLoading ? null : _login,
                  isLoading: authViewModel.isLoading,
                ),
                TextButton(
                  onPressed: () {
                    // Navegar para a tela de cadastro se existir
                    // context.push(AppRoutes.signup);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Funcionalidade de cadastro ainda não implementada.')),
                    );
                  },
                  child: const Text('Não tem uma conta? Cadastre-se'),
                ),
                TextButton(
                  onPressed: () {
                    // Navegar para a tela de esqueceu a senha se existir
                    // context.push(AppRoutes.forgotPassword);
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Funcionalidade de "Esqueci minha senha" ainda não implementada.')),
                    );
                  },
                  child: const Text('Esqueceu sua senha?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}