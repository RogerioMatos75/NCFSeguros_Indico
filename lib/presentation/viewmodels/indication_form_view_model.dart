import '../../data/models/indication_model.dart';
import '../../data/repositories/indication_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../services/notification_service.dart';
import 'base_view_model.dart';

class IndicationFormViewModel extends BaseViewModel {
  final IndicationRepository _indicationRepository;
  final UserRepository _userRepository;
  final NotificationService _notificationService;

  IndicationFormViewModel({
    required IndicationRepository indicationRepository,
    required UserRepository userRepository,
    required NotificationService notificationService,
  })  : _indicationRepository = indicationRepository,
        _userRepository = userRepository,
        _notificationService = notificationService;

  Future<bool> submitIndication({
    required String userId,
    required String friendName,
    required String friendEmail,
    required String friendPhone,
    String? notes,
  }) async {
    return await handleAsyncOperation(() async {
      // Validar telefone
      if (!_isValidPhone(friendPhone)) {
        throw Exception('Telefone inválido. Use o formato (XX) XXXXX-XXXX.');
      }

      // Buscar informações do usuário
      final user = await _userRepository.getUserById(userId);
      if (user == null) {
        throw Exception('Usuário não encontrado. Não foi possível registrar a indicação.');
      }

      // Criar indicação
      final indication = IndicationModel(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Temporário, será substituído pelo Firestore
        userId: userId,
        userName: user.name,
        friendName: friendName,
        friendEmail: friendEmail,
        friendPhone: friendPhone,
        status: IndicationStatus.pending,
        createdAt: DateTime.now(),
        notes: notes,
      );

      // Salvar indicação
      // A variável savedId não estava sendo usada, então podemos chamar o método diretamente.
      await _indicationRepository.createIndication(indication);

      // Enviar notificação
      await _notificationService.notify(
        'Nova Indicação',
        'Uma nova indicação foi recebida de ${user.name}',
      );

      return true;
    });
  }

  bool _isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^\([1-9]{2}\) [0-9]{4,5}-[0-9]{4}$');
    return phoneRegExp.hasMatch(phone);
  }
}
