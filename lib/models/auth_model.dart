import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/utils/constants.dart';

class AuthModel with ChangeNotifier {
  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        '${Constants.authBaseUrl}$urlFragment?key=AIzaSyB8W_vYu3gYYvPFHuS-aIXLupCb28i3Klw';

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
  }

  Future<void> signUp(String email, String password) async {
    _authenticate(email, password, 'signUp');
  }

  Future<void> signInWithPassword(String email, String password) async {
    _authenticate(email, password, 'signInWithPassword');
  }
}
