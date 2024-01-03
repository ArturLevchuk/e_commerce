import 'dart:convert';
import 'package:dio/dio.dart';

import '../utils/server_exception.dart';
import 'models/user_information.dart';
import 'abstract/user_settings_api.dart';

class FirebaseUserSettingsApi implements UserSettingsApi {
  final String webDatabaseUrl =
      'https://e-commerce-26828-default-rtdb.firebaseio.com';
  final String webKey = 'AIzaSyChOUUVJgZ-OicuvmXr6Q83O9spplyzNSk';
  final Dio dioClient = Dio();

  @override
  Future<UserInformation> getUserInformation({
    required String token,
    required String userId,
  }) async {
    try {
      final url = Uri.parse('$webDatabaseUrl/users/$userId.json?auth=$token');
      final response = await dioClient.getUri(url);
      final extractedData = response.data as Map<String, dynamic>;
      return UserInformation(
        adress: extractedData['adress'],
        name: extractedData['name'],
        phoneNumber: extractedData['phoneNumber'],
      );
    } catch (err) {
      throw ServerException();
    } 
  }

  @override
  Future<void> updateUserInformation({
    required UserInformation userInformation,
    required String token,
    required String userId,
  }) async {
    try {
      final url = Uri.parse('$webDatabaseUrl/users/$userId.json?auth=$token');
      await dioClient.patchUri(url,
          data: json.encode({
            "adress": userInformation.adress,
            "name": userInformation.name,
            "phoneNumber": userInformation.phoneNumber,
          }));
    } catch (err) {
      throw ServerException();
    } 
  }
}
