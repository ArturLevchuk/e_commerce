import 'dart:convert';
import 'package:dio/dio.dart';
import '/utils/server_exception.dart';

import 'abstract/auth_api.dart';
import '../utils/auth_exception.dart';

class FirebaseAuthApi implements AuthApi {
  final String webDatabaseUrl =
      'https://e-commerce-26828-default-rtdb.firebaseio.com';
  final String webKey = 'AIzaSyChOUUVJgZ-OicuvmXr6Q83O9spplyzNSk';

  final Dio dioClient = Dio();

  Future<({String token, String userId, DateTime expiryDate})> _authenticate({
    required String email,
    required String password,
    required String urlSegment,
  }) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$webKey');
    late final String token;
    late final String userId;
    late final DateTime expiryDate;
    try {
      final response = await dioClient.postUri(url,
          data: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = response.data;
      token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(
        responseData['expiresIn'],
      )));
      return (token: token, userId: userId, expiryDate: expiryDate);
    } on DioError catch (err) {
      throw AuthException(err.response?.data['error']['message']);
    } catch (err) {
      throw ServerException();
    }
  }

  @override
  Future<({String token, String userId, DateTime expiryDate})> login(
      {required String email, required String password}) async {
    try {
      final authenticateRes = await _authenticate(
        email: email,
        password: password,
        urlSegment: 'signInWithPassword',
      );
      return (
        token: authenticateRes.token,
        userId: authenticateRes.userId,
        expiryDate: authenticateRes.expiryDate,
      );
    } catch (err) {
      throw ServerException();
    }
  }

  @override
  Future<({String token, String userId, DateTime expiryDate})> signUp(
      Map<String, String> args) async {
    try {
      final authenticateRes = await _authenticate(
        email: args['email']!,
        password: args['password']!,
        urlSegment: 'signUp',
      );
      final url = Uri.parse(
          '$webDatabaseUrl/users/${authenticateRes.userId}.json?auth=${authenticateRes.token}');
      await dioClient.putUri(
        url,
        data: json.encode(
          {
            'email': args['email'],
            'password': args['password'],
            'name': args['name'],
            'phoneNumber': args['phoneNumber'],
            'adress': args['adress'],
          },
        ),
      );
      return (
        token: authenticateRes.token,
        userId: authenticateRes.userId,
        expiryDate: authenticateRes.expiryDate
      );
    } on DioError catch (err) {
      throw AuthException(err.response?.data['error']['message']);
    } catch (err) {
      throw ServerException();
    }
  }
}
