abstract interface class AuthApi {
  Future<({String token, String userId, DateTime expiryDate})>
      login({required String email, required String password});

  Future<({String token, String userId, DateTime expiryDate})>
      signUp(Map<String, String> args);
}
