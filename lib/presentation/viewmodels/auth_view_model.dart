import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart'; // Import UserRepository
import 'base_view_model.dart';

class AuthViewModel extends BaseViewModel {
  final AuthService _authService;
  final UserRepository _userRepository; // Adicionar UserRepository
  UserModel? _currentUser;

  AuthViewModel({
    required AuthService authService,
    required UserRepository userRepository, // Adicionar ao construtor
  })  : _authService = authService,
        _userRepository = userRepository; // Inicializar UserRepository

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  Future<void> signIn(String email, String password) async {
    await handleAsyncOperation(() async {
      // Chamada com argumentos posicionais, conforme indicado pelos erros
      _currentUser = await _authService.signInWithEmailAndPassword(email, password);
      notifyListeners();
    });
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    await handleAsyncOperation(() async {
      _currentUser = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await handleAsyncOperation(() async {
      await _authService.signOut();
      _currentUser = null;
      notifyListeners();
    });
  }

  Future<void> resetPassword(String email) async {
    await handleAsyncOperation(() async {
      // Corrigido: sendPasswordResetEmail espera um argumento posicional
      await _authService.sendPasswordResetEmail(email);
    });
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
  }) async {
    await handleAsyncOperation(() async {
      if (_currentUser != null) {
        // Usar UserRepository para atualizar dados no Firestore
        await _userRepository.updateUser(_currentUser!.id, {
          'name': name,
          'phone': phone,
          // 'updatedAt': DateTime.now(), // UserRepository pode lidar com isso internamente
        });
        // Recarregar o UserModel atualizado
        _currentUser = await _userRepository.getUserById(_currentUser!.id);

        // TODO: Se 'name' também deve atualizar o displayName do Firebase Auth,
        // adicione uma chamada ao AuthService para isso. Ex:
        // await _authService.updateFirebaseDisplayName(name);
        notifyListeners();
      }
    });
  }
}
