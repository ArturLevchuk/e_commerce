class ConnectionException implements Exception {
  ConnectionException();
  @override
  String toString() {
    return "Connection error. Please check your internet connection";
  }
}
