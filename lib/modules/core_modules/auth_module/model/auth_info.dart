part of "../vm/auth_controller.dart";

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

@immutable
class AuthInfo {
  final String token;
  final String id;
  final AuthStatus authStatus;
  // final String? error;

  const AuthInfo( {
    this.token = "",
    this.id = "",
    this.authStatus = AuthStatus.unknown,
    // this.error,
  });

  AuthInfo copyWith(
      {String? token,
      String? id,
      AuthStatus? authStatus, String? error}) {
    return AuthInfo(
      token: token ?? this.token,
      id: id ?? this.id,
      authStatus: authStatus ?? this.authStatus,
      // error: error,
    );
  }
}
