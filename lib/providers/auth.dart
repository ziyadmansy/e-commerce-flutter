import 'dart:async';
import 'dart:convert';

import 'package:e_commerce_app/exceptions/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final response = await post(urlSegment,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final decodedResponseBody = json.decode(response.body);
      if (decodedResponseBody['error'] != null) {
        throw HttpException(decodedResponseBody['error']['message']);
      }
      _token = decodedResponseBody['idToken'];
      _userId = decodedResponseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(decodedResponseBody['expiresIn'])),
      );
      autoLogoutUser();
      notifyListeners();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUpUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAhkX2WhW2g3pefFDkLN3NcnH_FkbDJFFQ';
    await _authenticate(email, password, url);
  }

  Future<void> signInUser(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAhkX2WhW2g3pefFDkLN3NcnH_FkbDJFFQ';
    await _authenticate(email, password, url);
  }

  void logoutUser() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogoutUser() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final expirySeconds = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: expirySeconds), () {
      logoutUser();
    });
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      print('contains the key userData');
      final userData = prefs.getString('userData');
      final Map<String, Object> extractedUserData = json.decode(userData);
      final expiredDate = DateTime.parse(extractedUserData['expiryDate']);

      if (expiredDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = expiredDate;
      print('not expired');
      notifyListeners();
      autoLogoutUser();
      return true;
    } else {
      return false;
    }
  }
}
