import 'dart:io';

import 'package:bellbuoy_mobile/dtos/authentication_dto.dart';
import 'package:bellbuoy_mobile/services/authentication_service.dart';
import 'package:bellbuoy_mobile/ui/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';

import '../helpers/enums/authentication_results.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Main();
}

class _Main extends State<Login> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    var space = const SizedBox(height: 20);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png'),
                    space,
                    space,
                    TextFormField(
                      controller: usernameController,
                      restorationId: 'username_field',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                      ),
                      maxLines: 1,
                    ),
                    space,
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      restorationId: 'password_field',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      maxLines: 1,
                    ),
                    space,
                    ElevatedButton.icon(
                      onPressed: () {
                        isLoading
                            ? null
                            : attemptLogin(usernameController.text,
                                passwordController.text);
                      },
                      icon: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.teal,
                            )
                          : const Icon(Icons.login),
                      label: Text(
                        isLoading ? ' ' : 'Login',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLoading ? Colors.white : Colors.teal,
                        minimumSize: const Size(1000, 40),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),

                    /*TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),*/
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> attemptLogin(String username, String password) async {
    //showLoading("message");
    if (username.isNotEmpty && password.isNotEmpty) {
      AuthenticationService authenticationService = AuthenticationService();
      AuthenticationDto dto = AuthenticationDto();
      dto.username = username;
      dto.password = password;
      var result = await authenticationService.authenticateUser(dto);
      switch (result) {
        case AuthResults.SUCCESS:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home(),
            ),
            (route) => false,
          );
          setState(() {
            isLoading = true;
          });
          break;
        case AuthResults.FAIL:
          showAlert("Something went wrong... Please try again");
          break;
        case AuthResults.INTERNETCONNECTION:
          showAlert("Please check your internet connection and try again");
          break;
        case AuthResults.INVALID:
          showAlert("Invalid user credentials");
          break;
      }
    } else {
      showAlert("Invalid user credentials");
    }
  }

  void showAlert(String message) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alert'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void showLoading(String message) {
    if (!Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: const CircularProgressIndicator(),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Okay'),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const CircularProgressIndicator(),
        ),
      );
    }
  }
}
