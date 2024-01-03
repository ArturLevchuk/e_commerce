part of '../vm/user_settings_controller.dart';

enum UserInfoStatus { unknown, loaded }

@immutable
class UserInfo {
  final UserInfoStatus userInfoStatus;
  final UserInformation userInformation;
  // final String? error;

  const UserInfo({
    this.userInfoStatus = UserInfoStatus.unknown,
    this.userInformation = const UserInformation.empty(),
    // this.error,
  });

  UserInfo copyWith({
    UserInfoStatus? userInfoStatus,
    UserInformation? userInformation,
    // String? error,
  }) {
    return UserInfo(
      userInfoStatus: userInfoStatus ?? this.userInfoStatus,
      userInformation: userInformation ?? this.userInformation,
      // error: error,
    );
  }
}
