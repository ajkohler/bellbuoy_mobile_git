import 'dart:io';

import 'package:bellbuoy_mobile/services/contact_us_service.dart';
import 'package:bellbuoy_mobile/ui/custom_app_bar.dart';
import 'package:bellbuoy_mobile/ui/nav_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var space = const SizedBox(height: 20);
    final messageController = TextEditingController();
    return Scaffold(
      appBar: const CustomAppBar(title: 'Contact Us', status: Status.Complete),
      drawer: const NavDrawer(),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    const Text(
                      "Use this to send a message to your portfolio manager",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    space,
                    TextFormField(
                      controller: messageController,
                      //obscureText: true,
                      restorationId: 'message_field',
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Message",
                      ),
                      maxLines: 5,
                    ),
                    space,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(1000, 40),
                      ),
                      onPressed: () {
                        sendMessage(messageController.text, context);
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage(String message, BuildContext context) async {
    var response = await ContactUsService().sendEmail(message);
    var alertMessage = "";
    if (response == 200) {
      alertMessage = "Message sent successfully";
    } else {
      alertMessage = "Something went wrong, please try again later";
    }
    showAlert(alertMessage, context);
  }

  void showAlert(String message, BuildContext context) {
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
}
