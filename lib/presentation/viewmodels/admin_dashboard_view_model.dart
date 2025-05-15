import 'package:get_it/get_it.dart';
import '../../data/models/indication_model.dart'; // Garante que IndicationStatus está acessível
import '../../data/models/user_model.dart';
import '../../data/repositories/indication_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/notification_service.dart';
import '../../services/event_bus_service.dart';
import 'base_view_model.dart';

class AdminDashboardViewModel extends BaseViewModel {
  final IndicationRepository _indicationRepository;
  final UserRepository _userRepository;
  final NotificationService _notificationService;
  final EventBusService _eventBusService;

  List<IndicationModel> _allIndications = [];
  List<UserModel> _allUsers = [];
  Map<String, int> _indicationStats = {};

  AdminDashboardViewModel()
      : _indicationRepository = GetIt.instance<IndicationRepository>(),
        _userRepository = GetIt.instance<UserRepository>(),
        _notificationService = GetIt.instance<NotificationService>(),
        _eventBusService = GetIt.instance<EventBusService>();

  List<IndicationModel> get allIndications => _allIndications;
  List<UserModel> get allUsers => _allUsers;
  Map<String, int> get indicationStats => _indicationStats;

  Future<void> loadDashboardData() async {
    await handleAsyncOperation(() async {
      await Future.wait([
        loadAllIndications(),
        loadAllUsers(),
      ]);
      _updateIndicationStats();
      notifyListeners();
    });
  }

  Future<void> loadAllIndications() async {
    _allIndications = await _indicationRepository.getAllIndications().first;
  }

  Future<void> loadAllUsers() async {
    _allUsers = await _userRepository.getAllUsers().first;
  }

  void _updateIndicationStats() {
    _indicationStats = {
      'total': _allIndications.length,
      'pendente': _allIndications.where((i) => i.status == IndicationStatus.pending).length,
      'contatado': _allIndications.where((i) => i.status == IndicationStatus.contacted).length,
      'convertido': _allIndications.where((i) => i.status == IndicationStatus.converted).length,
      'rejeitado': _allIndications.where((i) => i.status == IndicationStatus.rejected).length,
    };
  }

  IndicationStatus _stringToIndicationStatus(String status) {
    return IndicationStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status.toLowerCase(),
      orElse: () => IndicationStatus.pending, // Valor padrão em caso de não correspondência
    );
  }

  Future<void> updateIndicationStatus(
      String indicationId, String newStatus) async {
    await handleAsyncOperation(() async {
      final statusEnum = _stringToIndicationStatus(newStatus);
      await _indicationRepository.updateIndicationStatus(
          indicationId, statusEnum);
      await loadDashboardData();
      _eventBusService
          .emit(IndicationStatusUpdatedEvent(indicationId, newStatus)); // EventBus pode continuar com string se necessário
      _notificationService
          .showSuccess('Status da indicação atualizado com sucesso!');
    });
  }

  List<IndicationModel> filterIndicationsByStatus(String status) {
    return _allIndications
        .where((indication) => indication.status.toString().split('.').last == status.toLowerCase())
        .toList();
  }

  List<IndicationModel> searchIndications(String query) {
    query = query.toLowerCase();
    return _allIndications
        .where((indication) =>
            indication.friendName.toLowerCase().contains(query) ||
            indication.friendEmail.toLowerCase().contains(query) ||
            indication.friendPhone.contains(query))
        .toList();
  }

  List<UserModel> searchUsers(String query) {
    query = query.toLowerCase();
    return _allUsers
        .where((user) =>
            user.name.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.phone.contains(query))
        .toList();
  }

  Map<String, dynamic> getUserPerformanceStats(String userId) {
    final userIndications =
        _allIndications.where((i) => i.userId == userId).toList();
    final convertedIndications =
        userIndications.where((i) => i.status == IndicationStatus.converted).length;

    return {
      'totalIndications': userIndications.length,
      'convertedIndications': convertedIndications,
      'conversionRate': userIndications.isEmpty
          ? 0.0
          : (convertedIndications / userIndications.length) * 100,
    };
  }
}
