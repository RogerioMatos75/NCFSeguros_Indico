import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Repositories
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/indication_repository.dart';
import '../../data/repositories/user_repository.dart';

// Services
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';

// ViewModels
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/profile_viewmodel.dart';
import '../../presentation/viewmodels/indication_form_viewmodel.dart';
import '../../presentation/viewmodels/indication_list_viewmodel.dart';
import '../../presentation/viewmodels/admin_dashboard_viewmodel.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupInjector() async {
  // Firebase
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Services
  getIt.registerSingleton<AuthService>(AuthService(getIt<FirebaseAuth>()));
  getIt.registerSingleton<NotificationService>(NotificationService());

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(getIt<FirebaseAuth>())
  );
  getIt.registerSingleton<IndicationRepository>(
    IndicationRepository(getIt<FirebaseFirestore>())
  );
  getIt.registerSingleton<UserRepository>(
    UserRepository(getIt<FirebaseFirestore>())
  );

  // ViewModels
  getIt.registerFactory(() => AuthViewModel(
    authRepository: getIt<AuthRepository>(),
    userRepository: getIt<UserRepository>(),
  ));

  getIt.registerFactory(() => ProfileViewModel(
    userRepository: getIt<UserRepository>(),
  ));

  getIt.registerFactory(() => IndicationFormViewModel(
    indicationRepository: getIt<IndicationRepository>(),
    userRepository: getIt<UserRepository>(),
    notificationService: getIt<NotificationService>(),
  ));

  getIt.registerFactory(() => IndicationListViewModel(
    indicationRepository: getIt<IndicationRepository>(),
  ));

  getIt.registerFactory(() => AdminDashboardViewModel(
    indicationRepository: getIt<IndicationRepository>(),
    notificationService: getIt<NotificationService>(),
  ));
}