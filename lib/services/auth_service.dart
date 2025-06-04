import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:logger/logger.dart'; // Adicionado import do logger
import '../data/repositories/user_repository.dart';
import '../data/models/user_model.dart';
import 'package:get_it/get_it.dart';

class AuthService {
  final FirebaseAuth _auth;
  late final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Logger _logger = Logger(); // Instância do Logger

  AuthService(this._auth) {
    _userRepository = GetIt.instance<UserRepository>();
  }

  // Stream do estado de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuário atual
  User? get currentUser => _auth.currentUser;

  // Login com email e senha
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Atualizar último login
        await _userRepository.updateLastLogin(userCredential.user!.uid);

        // Buscar dados completos do usuário
        final userModel =
            await _userRepository.getUserById(userCredential.user!.uid);
        if (userModel == null) {
          _logger.w('Usuário ${userCredential.user!.uid} autenticado mas não encontrado no banco de dados.');
          throw 'Usuário não encontrado no banco de dados';
        }
        return userModel;
      }
      _logger.w('Login falhou: userCredential.user é nulo após signInWithEmailAndPassword.');
      throw 'Erro ao fazer login';
    } catch (e, stackTrace) {
      _logger.e('Erro em signInWithEmailAndPassword', error: e, stackTrace: stackTrace);
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
        // Atualizar o displayName no Firebase Auth imediatamente após o registro
        await userCredential.user!.updateDisplayName(name);

        // Criar modelo de usuário
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name, // Usar o nome fornecido
          phone: phone,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        // Salvar no Firestore
        await _userRepository.createUser(newUser);
        return newUser;
      }
      _logger.w('Registro falhou: userCredential.user é nulo após createUserWithEmailAndPassword.');
      throw 'Erro ao criar usuário';
    } catch (e, stackTrace) {
      _logger.e('Erro em registerWithEmailAndPassword', error: e, stackTrace: stackTrace);
      throw _handleAuthError(e);
    }
  }

  // Recuperação de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e, stackTrace) {
      _logger.e('Erro em sendPasswordResetEmail', error: e, stackTrace: stackTrace);
      throw _handleAuthError(e);
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      await _auth.signOut();
    } catch (e, stackTrace) {
      _logger.w('Erro durante o signOut de um provedor social. Tentando Firebase signOut.', error: e, stackTrace: stackTrace);
      try {
        await _auth.signOut(); // Garante que o signOut do Firebase seja tentado
      } catch (firebaseSignOutError, firebaseStackTrace) {
        _logger.e('Erro crítico ao tentar Firebase signOut após falha de provedor social.', error: firebaseSignOutError, stackTrace: firebaseStackTrace);
        throw _handleAuthError(firebaseSignOutError); // Relança o erro do Firebase se este também falhar
      }
      // Não relançar o erro original do provedor social se o signOut do Firebase for bem-sucedido
    }
  }

  // Verificar se usuário é admin
  Future<bool> isUserAdmin() async {
    try {
      if (currentUser == null) return false;
      return await _userRepository.isUserAdmin(currentUser!.uid);
    } catch (e, stackTrace) {
      _logger.e('Erro ao verificar se usuário é admin', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  // Login com Google
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.i('Login com Google cancelado pelo usuário.');
        throw 'Login com Google cancelado pelo usuário.';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        var userModel =
            await _userRepository.getUserById(userCredential.user!.uid);

        if (userModel == null) {
          _logger.i('Criando novo usuário no Firestore para login com Google: ${userCredential.user!.uid}');
          userModel = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userCredential.user!.displayName ?? 'Usuário Google',
            phone: userCredential.user!.phoneNumber ?? '',
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );
          await _userRepository.createUser(userModel);
        } else {
          await _userRepository.updateLastLogin(userCredential.user!.uid);
        }
        return userModel;
      }
      _logger.w('Login com Google falhou: userCredential.user é nulo.');
      throw 'Erro ao fazer login com Google: Usuário do Firebase nulo.';
    } catch (e, stackTrace) {
      _logger.e('Erro em signInWithGoogle', error: e, stackTrace: stackTrace);
      throw _handleAuthError(e);
    }
  }

  // Login com Facebook
  Future<UserModel> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          final userData = await FacebookAuth.instance.getUserData(
            fields: "name,email,picture.width(200)",
          );

          var userModel =
              await _userRepository.getUserById(userCredential.user!.uid);

          if (userModel == null) {
            _logger.i('Criando novo usuário no Firestore para login com Facebook: ${userCredential.user!.uid}');
            userModel = UserModel(
              id: userCredential.user!.uid,
              email: userData['email'] ?? userCredential.user!.email!,
              name: userData['name'] ?? userCredential.user!.displayName ?? 'Usuário Facebook',
              phone: userCredential.user!.phoneNumber ?? '',
              createdAt: DateTime.now(),
              lastLoginAt: DateTime.now(),
            );
            await _userRepository.createUser(userModel);
          } else {
            await _userRepository.updateLastLogin(userCredential.user!.uid);
          }
          return userModel;
        }
        _logger.w('Login com Facebook falhou: userCredential.user é nulo.');
        throw 'Erro ao fazer login com Facebook: Usuário do Firebase nulo.';
      } else {
        _logger.w('Login com Facebook falhou: ${result.message} (Status: ${result.status})');
        throw 'Login com Facebook falhou: ${result.message} (Status: ${result.status})';
      }
    } catch (e, stackTrace) {
      _logger.e('Erro em signInWithFacebook', error: e, stackTrace: stackTrace);
      throw _handleAuthError(e);
    }
  }

  // Atualizar o displayName no Firebase Auth
  Future<void> updateFirebaseUserDisplayName(String name) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(name);
      } catch (e, stackTrace) {
        _logger.w('Erro ao atualizar displayName no Firebase Auth', error: e, stackTrace: stackTrace);
      }
    }
  }

  // Definir a persistência da autenticação
  Future<void> setAuthPersistence(bool rememberMe) async {
    try {
      await _auth.setPersistence(rememberMe ? Persistence.LOCAL : Persistence.SESSION);
    } catch (e, stackTrace) {
      _logger.w('Erro ao definir persistência da autenticação', error: e, stackTrace: stackTrace);
    }
  }


  // Tratamento de erros de autenticação
  String _handleAuthError(dynamic e) {
    if (e is FirebaseAuthException) {
      _logger.i('FirebaseAuthException: Code: ${e.code}, Message: ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado. Verifique o e-mail digitado.';
        case 'wrong-password':
          return 'Senha incorreta. Tente novamente.';
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado. Tente fazer login ou use outro e-mail.';
        case 'invalid-email':
          return 'O formato do e-mail é inválido.';
        case 'weak-password':
          return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
        case 'operation-not-allowed':
          return 'Login com e-mail e senha não está habilitado.';
        case 'user-disabled':
          return 'Esta conta de usuário foi desabilitada.';
        case 'account-exists-with-different-credential':
          return 'Já existe uma conta com este e-mail usando um método de login diferente (Ex: Google, Facebook). Tente fazer login com esse método.';
        case 'invalid-credential':
          return 'A credencial fornecida é inválida ou expirou.';
        case 'requires-recent-login':
          return 'Esta operação é sensível e requer autenticação recente. Faça login novamente antes de tentar novamente esta solicitação.';
        case 'network-request-failed':
          return 'Falha na rede. Verifique sua conexão com a internet.';
        default:
          _logger.w('FirebaseAuthException não tratada explicitamente: Code: ${e.code}, Message: ${e.message}');
          return 'Ocorreu um erro de autenticação. Tente novamente mais tarde.';
      }
    } else if (e is String) {
      _logger.i('Erro de autenticação (String): $e');
      return e;
    }
    _logger.e('Erro de autenticação não identificado', error: e, stackTrace: (e is Error ? e.stackTrace : StackTrace.current));
    return 'Ocorreu um erro inesperado. Tente novamente.';
  }
}
