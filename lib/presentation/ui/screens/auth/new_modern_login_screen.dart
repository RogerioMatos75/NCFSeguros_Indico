import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../viewmodels/auth_view_model.dart'; // Verifique o caminho correto
import '../../../../core/constants/app_routes.dart'; // Corrigido o caminho para navegação

class NewModernLoginScreen extends StatefulWidget {
  const NewModernLoginScreen({super.key});

  @override
  State<NewModernLoginScreen> createState() => _NewModernLoginScreenState();
}

class _NewModernLoginScreenState extends State<NewModernLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Bem-vindo de volta!',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Faça login para continuar',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Campo de Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'seuemail@exemplo.com',
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Campo de Senha
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Sua senha',
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implementar navegação para tela de "Esqueci minha senha"
                          // Ex: context.push(AppRoutes.forgotPassword);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Funcionalidade "Esqueci senha" a ser implementada.')),
                          );
                        },
                        child: const Text('Esqueceu sua senha?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (authViewModel.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            await authViewModel.signIn(
                              // Corrigido o nome do método
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            // A navegação em caso de sucesso é tratada pelo redirect do GoRouter.
                            // Em caso de erro, o AuthViewModel deve atualizar seu estado 'error'.
                          }
                        },
                        child: const Text('ENTRAR',
                            style: TextStyle(fontSize: 16)),
                      ),
                    if (authViewModel.error != null && !authViewModel.isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          authViewModel.error!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Não tem uma conta?'),
                        TextButton(
                          onPressed: () {
                            context.push(AppRoutes
                                .signup); // Navega para a tela de cadastro
                          },
                          child: const Text('Crie uma aqui'),
                        ),
                      ],
                    ),
                    // TODO: Adicionar opções de login social (Google, Facebook, etc.) se necessário
                  ],
                ),
              ),
            ),
          ), // Fim do Expanded do formulário
        ], // Fim da Row principal
      ),
    );
  }
}
