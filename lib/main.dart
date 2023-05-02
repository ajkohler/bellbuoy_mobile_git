import 'package:bellbuoy_mobile/services/authentication_service.dart';
import 'package:bellbuoy_mobile/ui/home.dart';
import 'package:bellbuoy_mobile/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  Widget _defaultHome = new Login();

  // Get result of the login function.
  bool _result = await AuthenticationService().isUserLoggedIn();
  if (_result) {
    _defaultHome = new Home();
  }
  runApp(
    Phoenix(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bellbuoy',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: _defaultHome,
      ),
    ),
  );
}
