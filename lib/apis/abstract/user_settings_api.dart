import '../models/user_information.dart';

abstract interface class UserSettingsApi {
  Future<UserInformation> getUserInformation({
    required String token,
    required String userId,
  });

  Future<void> updateUserInformation({
    required UserInformation userInformation,
    required String token,
    required String userId,
  });
}
