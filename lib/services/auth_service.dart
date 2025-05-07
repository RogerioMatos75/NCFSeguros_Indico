import 'package:firebase_auth/firebase_auth.dart';
import '../data/repositories/user_repository.dart';
import '../data/models/user_model.dart';
import 'package:get_it/get_it.dart';

class AuthService {
  final FirebaseAuth _auth;
  late final UserRepository _userRepository;

  AuthService(this._auth) {
    _userRepository = GetIt.instance<UserRepository>();
  }

  // Stream do estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Login com email e senha
  Future<UserModel> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Atualizar último login
        await _userRepository.updateLastLogin(userCredential.user!.uid);
        
        // Buscar dados completos do usuário
        final userModel = await _userRepository.getUserById(userCredential.user!.uid);
        if (userModel == null) {
          throw 'Usuário não encontrado no banco de dados';
        }
        return userModel;
      }
      throw 'Erro ao fazer login';
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Registro de novo usuário
  Future<UserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Criar modelo de usuário
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          phone: phone,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        // Salvar no Firestore
        await _userRepository.createUser(newUser);
        return newUser;
      }
      throw 'Erro ao criar usuário';
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Recuperação de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Verificar se usuário é admin
  Future<bool> isUserAdmin() async {
    try {
      if (currentUser == null) return false;
      return await _userRepository.isUserAdmin(currentUser!.uid);
    } catch (e) {
      return false;
    }
  }

  // Tratamento de erros de autenticação
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado';
        case 'wrong-password':
          return 'Senha incorreta';
        case 'email-already-in-use':
          return 'E-mail já está em uso';
        case 'invalid-email':
          return 'E-mail inválido';
        case 'weak-password':
          return 'Senha muito fraca';
        case 'operation-not-allowed':
          return 'Operação não permitida';
        case 'user-disabled':
          return 'Usuário desativado';
        default:
          return 'Erro de autenticação: ${e.message}';
      }
    }
    return e.toString();
  }
}