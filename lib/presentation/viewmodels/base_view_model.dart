import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<T> handleAsyncOperation<T>(Future<T> Function() operation) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      T result = await operation();
      return result;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
