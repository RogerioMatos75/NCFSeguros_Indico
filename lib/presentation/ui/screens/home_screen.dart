import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_routes.dart';
// Mantido pois authService é usado
import '../../viewmodels/home_screen_view_model.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeScreenViewModel>().loadIndications();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authService = getIt<AuthService>(); // authService não é mais usado diretamente aqui
    final viewModel = context.watch<HomeScreenViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('NCF Seguros Indico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo(a)!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Indique amigos e familiares interessados em seguros e ganhe descontos na renovação da sua apólice.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Nova Indicação',
              onPressed: () => context.push(AppRoutes.newIndication),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Minhas Indicações',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.isLoading
                    ? 1
                    : viewModel.indications.isEmpty
                        ? 1
                        : viewModel.indications.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  if (viewModel.isLoading) {
                    return const ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Carregando indicações...'),
                    );
                  }

                  if (viewModel.indications.isEmpty) {
                    return const ListTile(
                      title: Text('Nenhuma indicação encontrada'),
                      subtitle: Text('Faça sua primeira indicação agora!'),
                    );
                  }

                  final indication = viewModel.indications[index];
                  return ListTile(
                    title: Text(indication.name),
                    subtitle: Text(
                      'Status: ${indication.status}\n${indication.email}\n${indication.phone}',
                    ),
                    trailing: _getStatusIcon(indication.status),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.newIndication),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pendente':
        return const Icon(Icons.pending, color: Colors.orange);
      case 'aprovado':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'rejeitado':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }
}
