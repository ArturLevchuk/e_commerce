class ServerException implements Exception {
  ServerException();
  @override
  String toString() {
    return "Server error. Please try later";
  }
}
