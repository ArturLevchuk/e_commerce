class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    print(message);
    final errMessage = message.split(' : ')[0];
    if (int.tryParse(errMessage) != null) {
      return "Service error $errMessage. Please try later";
    }
    switch (errMessage) {
      case 'EMAIL_EXISTS':
        return 'The email address is already in use by another account';
      case 'EMAIL_NOT_FOUND':
        return 'There is no user record corresponding to this identifier';
      case 'INVALID_PASSWORD':
        return 'The password is invalid ';
      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        return 'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.';
      default:
        return "Service error. Please try later";
    }
  }
}
