import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Adicionar import do Provider
import 'package:get_it/get_it.dart'; // Adicionar import do GetIt
import 'core/di/injector.dart';
import 'presentation/ui/navigation/app_router.dart';
import 'presentation/viewmodels/auth_view_model.dart'; // Importar AuthViewModel
import 'presentation/viewmodels/home_screen_view_model.dart'; // Importar HomeScreenViewModel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupInjector(); // Inicializa injeção de dependência

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<AuthViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => GetIt.instance<HomeScreenViewModel>(),
        ),
        // Adicione outros providers globais aqui se necessário
      ],
      child: MaterialApp.router(
        title: 'NCF Seguros Indico',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerConfig: appRouter, // Configuração do GoRouter
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
