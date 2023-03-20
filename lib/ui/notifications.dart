import 'package:bellbuoy_mobile/services/notification_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dtos/notification_dto.dart';
import 'custom_app_bar.dart';
import 'nav_drawer.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Notifications> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Notifications> {
  List<NotificationDto> notificationList = [];

  @override
  void initState() {
    super.initState();
    getNotifications();
    updateNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const CustomAppBar(title: "Notifications", status: Status.Complete),
      drawer: const NavDrawer(),
      body: Column(
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
                            return Card(
                                child: ListTile(
                              title: Text(notificationList[index].message),
                              subtitle: Text(
                                  '${DateTime.parse(notificationList[index].date.substring(0, 10)).day.toString()}/${DateTime.parse(notificationList[index].date.substring(0, 10)).month.toString()}/${DateTime.parse(notificationList[index].date.substring(0, 10)).year.toString()}'),
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
    );
  }

  Future<void> getNotifications() async {
    await NotificationService().getNotifications().then((value) => {
          setState(() {
            notificationList = value;
          })
        });
  }

  updateNotifications() async {
    await NotificationService().updateNotifications().then((value) async => {
          await NotificationService().getNotifications().then((value) => {
                setState(() {
                  notificationList = value;
                })
              })
        });
  }
}
