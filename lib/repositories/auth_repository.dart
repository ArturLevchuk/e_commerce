import 'dart:async';
import 'dart:convert';
import 'package:e_commerce/utils/HttpException.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/user_information.dart';

const webKey = 'AIzaSyChOUUVJgZ-OicuvmXr6Q83O9spplyzNSk';

class AuthRepositiry {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  final _authStreamController = StreamController<bool>();
  Stream<bool> authStatus() => _authStreamController.stream;

  Future<void> _authenticate(String email, String password, String urlSegment,
      [bool remember = true]) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$webKey');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(
        responseData['expiresIn'],
      )));
      _authStreamController.add(true);
      _autoLogout();

      if (remember) {
        SharedPreferences.getInstance().then((prefs) {
          final userData = json.encode({
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate!.toIso8601String(),
          });
          prefs.setString('userData', userData);
        });
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signup(Map<String, String> args) async {
    try {
      await _authenticate(args['email']!, args['password']!, 'signUp');
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token');
      final response = await http.put(
        url,
        body: json.encode({
          'email': args['email'],
          'password': args['password'],
          'name': args['name'],
          'phoneNumber': args['phoneNumber'],
          'adress': args['adress'],
        }),
      );
      if (response.statusCode >= 400) {
        throw HttpException('${response.statusCode}');
      }
    } on HttpException catch (_) {
      rethrow;
    } catch (err) {
      throw HttpException(err.toString());
    }
  }

  Future<void> login(String email, String password, bool remember) async {
    try {
      await _authenticate(email, password, 'signInWithPassword', remember);
    } on HttpException catch (_) {
      rethrow;
    } catch (err) {
      throw HttpException(err.toString());
    }
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      _authStreamController.add(false);
      return;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      _authStreamController.add(false);
      return;
    }
    _token = extractedUserData['token'];
    _expiryDate = expiryDate;
    _userId = extractedUserData['userId'];

    _autoLogout();

    _authStreamController.add(true);
    return;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId ?? '';
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    _authStreamController.add(false);
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<UserInformation> getUserInformation() async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token');
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw HttpException('${response.statusCode}');
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      return UserInformation(
        adress: extractedData['adress'],
        name: extractedData['name'],
        phoneNumber: extractedData['phoneNumber'],
      );
    } on HttpException {
      rethrow;
    } catch (err) {
      throw HttpException(err.toString());
    }
  }

  Future<void> updateUserInformation(UserInformation userInformation) async {
    try {
      final url = Uri.parse(
          'https://e-commerce-26828-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token');
      final response = await http.patch(url,
          body: json.encode({
            "adress": userInformation.adress,
            "name": userInformation.name,
            "phoneNumber": userInformation.phoneNumber,
          }));
      if (response.statusCode >= 400) {
        throw HttpException('${response.statusCode}');
      }
    } catch (err) {
      throw HttpException(err.toString());
    }
  }
}
