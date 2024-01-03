abstract interface class LocalStorageService {
  Future<void> set({required String key, required Map<String, dynamic> value});
  Future<Map<String, dynamic>> get({required String key});
  Future<void> remove({required String key});
}
