import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_view_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // Adicione outros controllers se necessário (ex: nome)

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Chamar o método de cadastro no AuthViewModel
      // Exemplo:
      // await authViewModel.signUp(
      //   _emailController.text.trim(),
      //   _passwordController.text.trim(),
      // );

      // if (mounted) {
      //   if (authViewModel.error == null && authViewModel.isAuthenticated) {
      //     context.go(AppRoutes.home); // Ou para login para o usuário entrar
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text(authViewModel.error ?? 'Falha no cadastro. Tente novamente.'),
      //         backgroundColor: Colors.red,
      //       ),
      //     );
      //   }
      // }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Lógica de cadastro a ser implementada no AuthViewModel!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastre-se'),
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
                // Você pode adicionar um logo ou imagem aqui também
                const SizedBox(height: 20.0),
                CustomTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Por favor, insira seu e-mail';
                    if (!value.contains('@'))
                      return 'Por favor, insira um e-mail válido';
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Senha',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Por favor, insira sua senha';
                    if (value.length < 6)
                      return 'A senha deve ter pelo menos 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Senha',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Por favor, confirme sua senha';
                    if (value != _passwordController.text)
                      return 'As senhas não coincidem';
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                // Adicionar exibição de erro do authViewModel se houver
                CustomButton(
                  text: 'Cadastrar',
                  onPressed: authViewModel.isLoading ? null : _signup,
                  isLoading: authViewModel.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
