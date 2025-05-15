import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import '../../../services/auth_service.dart';
import '../../../presentation/viewmodels/indication_form_view_model.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:go_router/go_router.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Indicação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<IndicationFormViewModel>();

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
