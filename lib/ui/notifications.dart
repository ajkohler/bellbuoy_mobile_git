import 'package:bellbuoy_mobile/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../classes/global.dart';
import '../dtos/notification_dto.dart';
import '../services/local_storage_service.dart';
import 'custom_app_bar.dart';
import 'nav_drawer.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Notifications> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Notifications> {
  List notificationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(title: "Notifications", status: Status.Complete),
      drawer: const NavDrawer(),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          backgroundColor: Colors.teal,
          onRefresh: fetchNotifications,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  width: 480,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      notificationList.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: notificationList.length,
                              itemBuilder: (BuildContext context, int index) {
                                final notification =
                                    notificationList[index] as Map;

                                return Card(
                                    child: ListTile(
                                  title: Text(notification['message']),
                                  subtitle: Text(notification['date']),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      postDeactivatedNotification(
                                          notification['id']);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(10, 18)),
                                    child: const Text('Delete'),
                                  ),
                                ));
                              })
                          : const ListTile(
                              title: Text("No Notifications"),
                              subtitle: Text(""),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchNotifications() async {
    final response = await NotificationService.getAllNotification();
    if (response != null) {
      setState(() {
        notificationList = response;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> postDeactivatedNotification(int id) async {
    var body = {
      'MessageUserId': id,
    };
    var uri = Uri.parse('${Global.getMessageDeleteEndpoint}?messageUserId=$id');
    var response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final filtered =
          notificationList.where((element) => element['id'] != id).toList();
      setState(() {
        notificationList = filtered;
      });
    }
  }
}
