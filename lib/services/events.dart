import '../data/models/indication_model.dart';

// Eventos base
abstract class Event {}

// Eventos relacionados a indicações
class IndicationStatusUpdatedEvent extends Event {
  final String indicationId;
  final String newStatus;

  IndicationStatusUpdatedEvent(this.indicationId, this.newStatus);
}

class NewIndicationEvent extends Event {
  final IndicationModel indication;

  NewIndicationEvent(this.indication);
}

class IndicationDeletedEvent extends Event {
  final String indicationId;

  IndicationDeletedEvent(this.indicationId);
}

// Eventos relacionados a usuários
class UserUpdatedEvent extends Event {
  final String userId;
  final Map<String, dynamic> updates;

  UserUpdatedEvent(this.userId, this.updates);
}

class UserDeletedEvent extends Event {
  final String userId;

  UserDeletedEvent(this.userId);
}

// Eventos relacionados a notificações
class NewNotificationEvent extends Event {
  final String title;
  final String message;
  final String? userId;

  NewNotificationEvent({
    required this.title,
    required this.message,
    this.userId,
  });
}
