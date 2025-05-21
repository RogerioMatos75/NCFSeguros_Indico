import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../../../services/auth_service.dart';
import '../../../presentation/viewmodels/indication_form_view_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
// Adicionado para usar AppRoutes

class NewIndicationScreen extends StatefulWidget {
  const NewIndicationScreen({super.key});

  @override
  State<NewIndicationScreen> createState() => _NewIndicationScreenState();
}

class _NewIndicationScreenState extends State<NewIndicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _authService = GetIt.instance<AuthService>();

  @override
  void initState() {
    super.initState();
    // A lógica de redirecionamento baseada na autenticação agora é centralizada no app_router.dart.
    // _initializeApp(); // Removido para evitar conflitos de navegação.
  }

  // Future<void> _initializeApp() async { ... } // Método removido

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final viewModel = context.read<IndicationFormViewModel>();
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        // Idealmente, o usuário não deveria chegar aqui se não estiver autenticado,
        // mas é uma boa prática verificar.
        // Poderia redirecionar para login ou mostrar uma mensagem.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não autenticado.')),
        );
        return;
      }

      await viewModel.submitIndication(
        userId: currentUser.uid,
        friendName: _nameController.text.trim(),
        friendEmail: _emailController.text.trim(),
        friendPhone: _phoneController.text.trim(),
        notes: _notesController.text.trim(),
      );

      if (mounted) {
        if (viewModel.error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Indicação enviada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          // Decide se deve fazer pop ou navegar para outra tela após o envio.
          // context.pop(); // Se esta tela foi empurrada sobre outra.
          // context.go(AppRoutes.home); // Se deve ir para home após o envio bem-sucedido.
        } else {
          // O erro já é tratado no widget build, mas pode adicionar um SnackBar aqui também se desejar.
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IndicationFormViewModel>();

    // Durante o _initializeApp, o formulário será exibido.
    // Você pode querer mostrar uma UI de splash diferente aqui
    // enquanto `_initializeApp` está em execução, se o formulário não deve ser visível.
    // Por exemplo, usando um bool `_isLoadingSplash` e mostrando um CircularProgressIndicator.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Indicação'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Nome do Indicado',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: 'E-mail do Indicado',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, insira o e-mail';
                  }
                  if (!value!.contains('@')) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: 'Telefone do Indicado',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _notesController,
                label: 'Observações (opcional)',
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              if (viewModel.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    viewModel.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              CustomButton(
                text: 'Enviar Indicação',
                onPressed: viewModel.isLoading ? null : _handleSubmit,
                isLoading: viewModel.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
