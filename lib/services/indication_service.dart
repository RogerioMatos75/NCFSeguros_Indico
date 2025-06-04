import 'package:logger/logger.dart';
import '../data/repositories/indication_repository.dart';
import '../domain/models/indication.dart';
import '../data/models/indication_model.dart';

class IndicationService {
  final IndicationRepository _repository;
  final Logger _logger = Logger();

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
        notes: indication.notes, // Adicionado para garantir que as notas sejam passadas
      );
      await _repository.createIndication(model);
      _logger.i('Indicação criada com sucesso para o usuário ${indication.userId}, ID: ${indication.id}');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Erro ao criar indicação', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<bool> updateIndicationStatus(
      String indicationId, String status) async {
    try {
      final indicationStatus = _stringToIndicationStatus(status);
      await _repository.updateIndicationStatus(indicationId, indicationStatus);
      _logger.i('Status da indicação $indicationId atualizado para $status');
      return true;
    } catch (e, stackTrace) {
      _logger.e('Erro ao atualizar status da indicação $indicationId', error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Future<List<Indication>> getUserIndications(String userId) async {
    try {
      final indicationsStream = _repository.getUserIndications(userId);
      final modelsList = await indicationsStream.first;
      return modelsList.map((model) => _convertToIndication(model)).toList();
    } catch (e, stackTrace) {
      _logger.e('Erro ao buscar indicações para o usuário $userId', error: e, stackTrace: stackTrace);
      return []; // Retorna lista vazia em caso de erro para não quebrar a UI
    }
  }

  // Métodos auxiliares privados
  Indication _convertToIndication(IndicationModel model) {
    return Indication(
      id: model.id,
      userId: model.userId,
      name: model.friendName,
      email: model.friendEmail,
      phone: model.friendPhone,
      status: model.status.toString().split('.').last, // Converte enum para string
      createdAt: model.createdAt,
      notes: model.notes,
    );
  }

  IndicationStatus _stringToIndicationStatus(String status) {
    // Usar toLowerCase para garantir a correspondência independentemente do case
    return switch (status.toLowerCase()) {
      'pending' => IndicationStatus.pending,
      'contacted' => IndicationStatus.contacted,
      'converted' => IndicationStatus.converted,
      'rejected' => IndicationStatus.rejected,
      _ => IndicationStatus.pending, // Default para pending se o status for desconhecido
    };
  }
}
