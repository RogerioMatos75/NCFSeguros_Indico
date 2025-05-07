import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'users';

  UserRepository(this._firestore);

  // Criar novo usuário
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore.collection(_collection).doc(user.id).set(user.toMap());
    } catch (e) {
      throw 'Erro ao criar usuário: $e';
    }
  }

  // Buscar usuário por ID
  Future<UserModel?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar usuário: $e';
    }
  }

  // Atualizar dados do usuário
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar usuário: $e';
    }
  }

  // Atualizar desconto do usuário
  Future<void> updateUserDiscount(String id, double newDiscount) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'currentDiscount': newDiscount.clamp(0.0, 0.10), // Máximo de 10% de desconto
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar desconto: $e';
    }
  }

  // Incrementar contadores de indicações
  Future<void> incrementIndicationCounters(String id, bool wasConverted) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'totalIndications': FieldValue.increment(1),
        if (wasConverted) 'convertedIndications': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar contadores: $e';
    }
  }

  // Verificar se usuário é admin
  Future<bool> isUserAdmin(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['isAdmin'] ?? false;
      }
      return false;
    } catch (e) {
      throw 'Erro ao verificar permissões: $e';
    }
  }

  // Buscar todos os usuários (para admin)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromFirestore(doc))
            .toList());
  }

  // Atualizar último login
  Future<void> updateLastLogin(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar último login: $e';
    }
  }
}