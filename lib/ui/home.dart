import 'package:bellbuoy_mobile/dtos/portfolio_manager_dto.dart';
import 'package:bellbuoy_mobile/dtos/scheme_member_dto.dart';
import 'package:bellbuoy_mobile/dtos/token_dto.dart';
import 'package:bellbuoy_mobile/services/home_service.dart';
import 'package:bellbuoy_mobile/services/local_storage_service.dart';
import 'package:bellbuoy_mobile/ui/custom_app_bar.dart';
import 'package:bellbuoy_mobile/ui/nav_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homeState();
  }
}

class _homeState extends State<Home> {
  late Status _updatingStatus;
  List<SchemeMemberDto> memberList = [];
  List<PortfolioManagerDto> portfolioManagers = [];
  late final FirebaseMessaging _messaging;

  //PushNotification? _notificationInfo;

  @override
  void initState() {
    super.initState();
    getSchemeInfo();
    updateData();
    requestAndRegisterNotification();
  }

  void requestAndRegisterNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await _messaging.getToken();
      if (token != null) {
        var account = await LocalStorageService().username();
        var dto = TokenDto(token, account);
        HomeService().saveToken(dto);
      }

      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("===");
        print("Recieved ${message.notification?.body}");
        print("===");
        // Parse the message received
        // PushNotification notification = PushNotification(
        //   title: message.notification?.title,
        //   body: message.notification?.body,
        // );
        //
        // setState(() {
        //   _notificationInfo = notification;
        //   _totalNotifications++;
        // });
        // if (_notificationInfo != null) {
        //   // For displaying the notification as an overlay
        //   showSimpleNotification(
        //     Text(_notificationInfo!.title!),
        //     leading: NotificationBadge(totalNotifications: _totalNotifications),
        //     subtitle: Text(_notificationInfo!.body!),
        //     background: Colors.cyan.shade700,
        //     duration: Duration(seconds: 2),
        //   );
        // }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Home", status: _updatingStatus),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                child: SizedBox(
                  width: 480,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Text(
                          "Governing Body Members",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1dcab7)),
                        ),
                      ),
                      for (var element in memberList)
                        ListTile(
                          title: Text(element.name),
                          subtitle: Text(element.title),
                        ),
                      const Padding(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                        child: Text(
                          "Portfolio Managers",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1dcab7)),
                        ),
                      ),
                      for (var element in portfolioManagers)
                        ListTile(
                          title: Text(element.name),
                          subtitle: Text(element.description),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getSchemeInfo() async {
    setState(() {
      _updatingStatus = Status.Updating;
    });
    await HomeService().getHomeData().then((value) => {
          if (value.isEmpty)
            {updateData()}
          else
            {
              setState(() {
                memberList = value.toSet().toList();
              })
            }
        });
    await HomeService().getPortfolioManagers().then((value) => {
          if (value.isEmpty)
            {updateData()}
          else
            {
              setState(() {
                portfolioManagers = value;
              })
            }
        });
    setState(() {
      _updatingStatus = Status.Complete;
    });
  }

  updateData() async {
    setState(() {
      _updatingStatus = Status.Updating;
    });
    await HomeService().updateHomeData().then((value) => {getSchemeInfo()});

    if (mounted) {
      setState(() {
        _updatingStatus = Status.Complete;
      });
    }
  }
}
