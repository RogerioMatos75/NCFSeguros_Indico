import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart'; // Adicionar import do Provider
import 'core/di/injector.dart';
import 'presentation/ui/navigation/app_router.dart';
import 'presentation/viewmodels/auth_view_model.dart'; // Importar AuthViewModel
import 'presentation/viewmodels/home_screen_view_model.dart'; // Importar HomeScreenViewModel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          create: (_) => getIt<AuthViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => getIt<HomeScreenViewModel>(),
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
