import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import 'base_view_model.dart';

class ProfileViewModel extends BaseViewModel {
  final UserRepository _userRepository;
  UserModel? _userProfile;

  ProfileViewModel({
    required UserRepository userRepository,
  }) : _userRepository = userRepository;

  UserModel? get userProfile => _userProfile;

  Future<void> loadUserProfile(String userId) async {
    await handleAsyncOperation(() async {
      _userProfile = await _userRepository.getUserById(userId);
      notifyListeners();
    });
  }

  Future<void> updateProfile(String userId, String name, String phone) async {
    await handleAsyncOperation(() async {
      await _userRepository.updateUser(userId, {
        'name': name,
        'phone': phone,
        'updatedAt': DateTime.now(),
      });
      await loadUserProfile(userId);
    });
  }

  Future<void> updateUserDiscount(String userId, double newDiscount) async {
    await handleAsyncOperation(() async {
      await _userRepository.updateUserDiscount(userId, newDiscount);
      await loadUserProfile(userId);
    });
  }
}
