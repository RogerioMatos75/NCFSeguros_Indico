import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/indication_model.dart';

class IndicationRepository {
  final FirebaseFirestore _firestore;
  final String _collection = 'indications';

  IndicationRepository(this._firestore);

  // Criar nova indicação
  Future<String> createIndication(IndicationModel indication) async {
    try {
      final docRef = await _firestore.collection(_collection).add(indication.toMap());
      return docRef.id;
    } catch (e) {
      throw 'Erro ao criar indicação: $e';
    }
  }

  // Buscar indicação por ID
  Future<IndicationModel?> getIndicationById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return IndicationModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar indicação: $e';
    }
  }

  // Buscar indicações de um usuário
  Stream<List<IndicationModel>> getUserIndications(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IndicationModel.fromFirestore(doc))
            .toList());
  }

  // Buscar todas as indicações (para admin)
  Stream<List<IndicationModel>> getAllIndications() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IndicationModel.fromFirestore(doc))
            .toList());
  }

  // Atualizar status da indicação
  Future<void> updateIndicationStatus(
    String id,
    IndicationStatus status,
    {String? notes}
  ) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': status.toString().split('.').last,
        if (notes != null) 'notes': notes,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao atualizar status da indicação: $e';
    }
  }

  // Buscar estatísticas de indicações por usuário
  Future<Map<String, dynamic>> getUserIndicationStats(String userId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      int total = snapshot.docs.length;
      int converted = snapshot.docs
          .where((doc) => doc['status'] == IndicationStatus.converted.toString().split('.').last)
          .length;

      return {
        'total': total,
        'converted': converted,
        'pendingDiscount': (total * 0.01).clamp(0.0, 0.10), // Máximo de 10% de desconto
      };
    } catch (e) {
      throw 'Erro ao buscar estatísticas: $e';
    }
  }

  // Deletar indicação (apenas para testes ou casos específicos)
  Future<void> deleteIndication(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw 'Erro ao deletar indicação: $e';
    }
  }
}