import 'package:bellbuoy_mobile/services/authentication_service.dart';
import 'package:bellbuoy_mobile/ui/home.dart';
import 'package:bellbuoy_mobile/ui/login.dart';
import 'package:flutter/material.dart';

void main() async {
  Widget _defaultHome = new Login();

  // Get result of the login function.
  bool _result = await AuthenticationService().isUserLoggedIn();
  if (_result) {
    _defaultHome = new Home();
  }
  runApp(MaterialApp(
      title: 'Bellbuoy',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: _defaultHome));
}
