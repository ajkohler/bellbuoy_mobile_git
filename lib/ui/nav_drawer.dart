import 'dart:convert';
import 'dart:developer';

import 'package:bellbuoy_mobile/classes/user.dart';
import 'package:bellbuoy_mobile/services/approval_service.dart';
import 'package:bellbuoy_mobile/services/authentication_service.dart';
import 'package:bellbuoy_mobile/services/home_service.dart';
import 'package:bellbuoy_mobile/ui/approvals.dart';
import 'package:bellbuoy_mobile/ui/contact_us.dart';
import 'package:bellbuoy_mobile/ui/home.dart';
import 'package:bellbuoy_mobile/ui/notifications.dart';
import 'package:bellbuoy_mobile/ui/statements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

import '../classes/global.dart';
import '../services/authentication_service.dart';
import '../services/local_storage_service.dart';
import 'documents.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

enum Pages {
  HOME,
  STATEMENTS,
  APPROVALS,
  DOCUMENTS,
  NOTIFICATIONS,
  CONTACTUS,
  LOGIN
}

bool governBodyMember = false;

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String fullName = "";
  String emailAddress = "";
  late bool x;
  //late bool governBodyMember = false;
  List userDetailsList = [];

  @override
  void initState() {
    super.initState();
    getFullName().then((result) {
      setState(() {
        fullName = result;
      });
    });
    getEmailAddress().then((result) {
      emailAddress = result;
    });
    checkGovernBody().then((result) {
      setState(() {
        governBodyMember = result!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            margin: EdgeInsets.zero,
            accountName: Text(
              fullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              emailAddress,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            //currentAccountPictureSize: const Size.square(70.0),
            currentAccountPictureSize: const Size(250, 90),
            currentAccountPicture: SizedBox(
              width: 300,
              height: 40,
              child: Image.asset(
                'assets/images/logo_300.png',
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_rounded,
            ),
            title: const Text('Home'),
            onTap: () {
              navigate(Pages.HOME);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.newspaper_rounded,
            ),
            title: const Text('Statements'),
            onTap: () {
              navigate(Pages.STATEMENTS);
            },
          ),
          if (governBodyMember == true)
            ListTile(
              leading: const Icon(
                Icons.approval_rounded,
              ),
              title: const Text('Approvals'),
              onTap: () {
                navigate(Pages.APPROVALS);
              },
            ),
          ListTile(
            leading: const Icon(
              Icons.file_copy_rounded,
            ),
            title: const Text('Documents'),
            onTap: () {
              navigate(Pages.DOCUMENTS);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications,
            ),
            title: const Text('Notifications'),
            onTap: () async {
              navigate(Pages.NOTIFICATIONS);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.email_rounded,
            ),
            title: const Text('Contact Us'),
            onTap: () {
              navigate(Pages.CONTACTUS);
            },
          ),
          Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                children: <Widget>[
                  const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_rounded,
                    ),
                    title: const Text('Logout'),
                    onTap: () {
                      onLogoutTap(context);
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }

  void navigate(Pages page) async {
    Navigator.pop(context);
    await Future.delayed(const Duration(milliseconds: 200));
    Widget destination = Home();
    switch (page) {
      case Pages.HOME:
        destination = Home();
        break;
      case Pages.STATEMENTS:
        destination = const Statements();
        break;
      case Pages.APPROVALS:
        destination = const Approvals();
        break;
      case Pages.DOCUMENTS:
        destination = const Documents();
        break;
      case Pages.NOTIFICATIONS:
        destination = const Notifications(title: "Notifications");
        break;
      case Pages.CONTACTUS:
        destination = const ContactUs();
        break;
      case Pages.LOGIN:
        destination = Home();
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => destination,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void onLogoutTap(context) {
    AuthenticationService.logoutUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const Login(),
      ),
      (route) => false,
    );
    Restart.restartApp();
  }

  Future<String> getFullName() async {
    return await User().displayName;
  }

  Future<String> getEmailAddress() async {
    return await User().emailAddress;
  }

  Future<bool?> checkGovernBody() async {
    var username = await LocalStorageService().username();
    var getCheckGovernBodyUrl =
        Uri.parse('${Global.getGovernBodyEndpoint}?account=$username');

    var response = await http.get(getCheckGovernBodyUrl);

    if (response.statusCode == 200) {
      bool isGovernBody = jsonDecode(response.body);

      return isGovernBody;
      print(response.body);
    } else {
      return null;
    }
  }
}
