import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/indication.dart';
import '../../../core/di/injector.dart';
import '../../services/auth_service.dart';

class HomeScreenViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = getIt<AuthService>();

  List<Indication> _indications = [];
  bool _isLoading = false;
  String? _error;

  List<Indication> get indications => _indications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadIndications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        _error = 'Usuário não autenticado';
        return;
      }

      final snapshot = await _firestore
          .collection('indications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _indications =
          snapshot.docs.map((doc) => Indication.fromFirestore(doc)).toList();
    } catch (e) {
      _error = 'Erro ao carregar indicações: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addIndication({
    required String name,
    required String email,
    required String phone,
    String? notes,
  }) async {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final indication = Indication(
        id: '', // Será gerado pelo Firestore
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        status: 'pendente',
        createdAt: DateTime.now(),
        notes: notes,
      );

      await _firestore.collection('indications').add(indication.toMap());

      await loadIndications(); // Recarrega a lista
    } catch (e) {
      _error = 'Erro ao adicionar indicação: $e';
      notifyListeners();
      rethrow;
    }
  }
}
