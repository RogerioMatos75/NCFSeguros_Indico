import 'package:get_it/get_it.dart';
import '../../data/models/indication_model.dart';
// Certifique-se de que IndicationStatus está acessível, geralmente via import de indication_model.dart
import '../../data/repositories/indication_repository.dart';
import 'base_view_model.dart';

class IndicationListViewModel extends BaseViewModel {
  final IndicationRepository _indicationRepository;
  List<IndicationModel> _indications = [];

  IndicationListViewModel()
      : _indicationRepository = GetIt.instance<IndicationRepository>();

  List<IndicationModel> get indications => _indications;

  Future<void> loadUserIndications(String userId) async {
    await handleAsyncOperation(() async {
      _indications = await _indicationRepository.getUserIndications(userId).first;
      notifyListeners();
    });
  }

  Future<void> refreshIndications(String userId) async {
    await loadUserIndications(userId);
  }

  double calculateTotalDiscount() {
    int successfulIndications = _indications
        .where((indication) => indication.status == IndicationStatus.converted)
        .length;

    // Cada indicação bem-sucedida gera 1% de desconto
    double discount = successfulIndications.toDouble();
    // Limite máximo de 10% de desconto
    return discount > 10 ? 10 : discount;
  }

  Map<String, int> getIndicationStats() {
    return {
      'total': _indications.length,
      'pendente': _indications.where((i) => i.status == IndicationStatus.pending).length,
      'contatado': _indications.where((i) => i.status == IndicationStatus.contacted).length,
      'convertido': _indications.where((i) => i.status == IndicationStatus.converted).length,
      'rejeitado': _indications.where((i) => i.status == IndicationStatus.rejected).length,
    };
  }

  List<IndicationModel> filterIndicationsByStatus(String status) {
    return _indications
        .where((indication) => indication.status.toString().split('.').last == status.toLowerCase()) // Comparar a string do enum
        .toList();
  }

  List<IndicationModel> searchIndications(String query) {
    query = query.toLowerCase();
    return _indications
        .where((indication) =>
            indication.friendName.toLowerCase().contains(query) ||
            indication.friendEmail.toLowerCase().contains(query) ||
            indication.friendPhone.contains(query))
        .toList();
  }
}
