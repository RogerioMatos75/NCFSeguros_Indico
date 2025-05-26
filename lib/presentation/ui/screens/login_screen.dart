import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../viewmodels/auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDDEEFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'assets/Logo_NCF.png',
                      height: 100,
                    ),
                    SizedBox(height: 24.0),
                    Text(
                      'Bem-vindo de volta!',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Por favor, entre com seus dados para acessar.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () => _signInWithProvider('google'),
                          style: _socialButtonStyle(context),
                          child: Icon(Icons.g_mobiledata, color: Colors.green, size: 32),
                        ),
                        OutlinedButton(
                          onPressed: () => _signInWithProvider('facebook'),
                          style: _socialButtonStyle(context),
                          child: Icon(Icons.facebook, color: Colors.blue),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    _dividerOr(),
                    SizedBox(height: 16.0),
                    Text(
                      'E-mail',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration('Digite seu email...'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Por favor, insira seu e-mail';
                        if (!value.contains('@')) return 'Por favor, insira um e-mail válido';
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration('••••••••').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
                        if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) => setState(() => _rememberMe = value!),
                            ),
                            Text('Lembrar-me'),
                          ],
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.forgotPassword),
                          child: Text(
                            'Esqueceu a senha?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    if (authViewModel.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          authViewModel.error!,
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: authViewModel.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 18.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: authViewModel.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Entrar'),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Ainda não tem uma conta? "),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.signup),
                          child: Text(
                            'Cadastre-se',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    );
  }

  ButtonStyle _socialButtonStyle(BuildContext context) {
    return OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      side: BorderSide(color: Colors.grey.shade300),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.2, 36),
    );
  }

  Widget _dividerOr() {
    return Row(
      children: <Widget>[
        Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OU',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Expanded(child: Divider()),
      ],
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authViewModel = context.read<AuthViewModel>();
      await authViewModel.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        rememberMe: _rememberMe,
      );

      if (mounted) {
        if (authViewModel.error == null && authViewModel.isAuthenticated) {
          context.go(AppRoutes.home);
        }
      }
    }
  }

  Future<void> _signInWithProvider(String provider) async {
    final authViewModel = context.read<AuthViewModel>();
    
    switch (provider) {
      case 'google':
        await authViewModel.signInWithGoogle();
        break;
      case 'facebook':
        await authViewModel.signInWithFacebook();
        break;
    }

    if (mounted && authViewModel.error == null && authViewModel.isAuthenticated) {
      context.go(AppRoutes.home);
    }
  }
}