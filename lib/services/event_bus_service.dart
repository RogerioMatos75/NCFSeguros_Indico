import 'dart:async';

class EventBusService {
  static final EventBusService _instance = EventBusService._internal();
  final _eventController = StreamController<Event>.broadcast();

  factory EventBusService() {
    return _instance;
  }

  EventBusService._internal();

  Stream<T> on<T>() {
    if (T == dynamic) {
      return _eventController.stream as Stream<T>;
    } else {
      return _eventController.stream.where((event) => event is T).cast<T>();
    }
  }

  void emit(Event event) {
    _eventController.add(event);
  }

  void dispose() {
    _eventController.close();
  }
}

abstract class Event {}

class IndicationStatusUpdatedEvent extends Event {
  final String indicationId;
  final String newStatus;

  IndicationStatusUpdatedEvent(this.indicationId, this.newStatus);
}

class UserDataUpdatedEvent extends Event {
  final String userId;

  UserDataUpdatedEvent(this.userId);
}
