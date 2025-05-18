import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class NcfLoginFormAdapted extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController adminKeyController;
  final bool obscurePassword;
  final bool isLoading;
  final Future<void> Function() handleLogin;
  final VoidCallback togglePassword;

  const NcfLoginFormAdapted({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.adminKeyController,
    required this.obscurePassword,
    required this.isLoading,
    required this.handleLogin,
    required this.togglePassword,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final titleStyle = GoogleFonts.inter(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: textTheme.headlineSmall?.color,
    );
    final subtitleStyle = GoogleFonts.inter(
      fontSize: 14,
      color: textTheme.bodySmall?.color,
    );
    final labelStyle = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textTheme.bodyMedium?.color?.withOpacity(0.7),
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Bem-vindo de volta!',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Por favor, insira seus dados.',
                style: subtitleStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text('E-mail', style: labelStyle),
              const SizedBox(height: 6),
              CustomTextField(
                label: 'E-mail',
                hint: 'Digite seu e-mail',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu e-mail';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Senha', style: labelStyle),
              CustomTextField(
                label: 'Senha',
                hint: 'Digite sua senha',
                controller: passwordController,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: theme.iconTheme.color?.withOpacity(0.7),
                    size: 20,
                  ),
                  onPressed: togglePassword,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Chave de Acesso Admin',
                hint: 'Digite a chave de administrador',
                controller: adminKeyController,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Entrar',
                onPressed: isLoading ? null : handleLogin,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
