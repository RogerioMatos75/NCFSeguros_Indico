import '../data/repositories/indication_repository.dart';
import '../domain/models/indication.dart';
import '../data/models/indication_model.dart';

class IndicationService {
  final IndicationRepository _repository;

  IndicationService(this._repository);

  Future<List<Indication>> getIndications() async {
    final indicationsStream = _repository.getAllIndications();
    final modelsList = await indicationsStream.first;
    return modelsList.map((model) => _convertToIndication(model)).toList();
  }

  Future<bool> createIndication(Indication indication) async {
    try {
      final model = IndicationModel(
        id: indication.id,
        userId: indication.userId,
        userName: '', // Será preenchido pelo repositório
        friendName: indication.name,
        friendEmail: indication.email,
        friendPhone: indication.phone,
        status: IndicationStatus.pending,
        createdAt: indication.createdAt,
      );
      await _repository.createIndication(model);
      return true;
    } catch (e) {
      print('Erro ao criar indicação: $e');
      return false;
    }
  }

  Future<bool> updateIndicationStatus(
      String indicationId, String status) async {
    try {
      final indicationStatus = _stringToIndicationStatus(status);
      await _repository.updateIndicationStatus(indicationId, indicationStatus);
      return true;
    } catch (e) {
      print('Erro ao atualizar status da indicação: $e');
      return false;
    }
  }

  Future<List<Indication>> getUserIndications(String userId) async {
    final indicationsStream = _repository.getUserIndications(userId);
    final modelsList = await indicationsStream.first;
    return modelsList.map((model) => _convertToIndication(model)).toList();
  }

  // Métodos auxiliares privados
  Indication _convertToIndication(IndicationModel model) {
    return Indication(
      id: model.id,
      userId: model.userId,
      name: model.friendName,
      email: model.friendEmail,
      phone: model.friendPhone,
      status: model.status.toString().split('.').last,
      createdAt: model.createdAt,
      notes: model.notes,
    );
  }

  IndicationStatus _stringToIndicationStatus(String status) {
    return switch (status.toLowerCase()) {
      'pending' => IndicationStatus.pending,
      'contacted' => IndicationStatus.contacted,
      'converted' => IndicationStatus.converted,
      'rejected' => IndicationStatus.rejected,
      _ => IndicationStatus.pending,
    };
  }
}
