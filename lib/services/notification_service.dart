import 'dart:convert';

import 'package:bellbuoy_mobile/dtos/notification_dto.dart';
import 'package:http/http.dart' as http;

import '../classes/global.dart';
import '../dtos/portfolio_manager_dto.dart';
import 'local_storage_service.dart';

//Dead code
class NotificationService {
  Future<List<NotificationDto>> getNotifications() async {
    List<NotificationDto> list = [];
    var notifications = await LocalStorageService().getNotifications();

    for (var item in notifications) {
      NotificationDto notification = NotificationDto.fromMap(item);
      list.add(notification);
    }
    return list;
  }

  //Dead Code
  Future<void> updateNotifications() async {
    var username = await LocalStorageService().username();
    var getNotificationUrl =
        Uri.parse('${Global.getNotificationsEndpoint}?username=$username');

    var response = await http.get(getNotificationUrl);

    if (response.statusCode == 200) {
      List dto = json.decode(response.body);
      if (dto.isNotEmpty) {
        await LocalStorageService().deleteNotification();
        var list = await LocalStorageService().getNotifications();
        for (var element in dto) {
          NotificationDto notificationDto = NotificationDto(
              element['id'], element['message'], element['date']);

          if (!list.contains(notificationDto)) {
            await LocalStorageService().insertNotification(notificationDto);
          }
        }
      }
    }
  }

  //Current working code
  static Future<List?> getAllNotification() async {
    var username = await LocalStorageService().username();
    var getNotificationUrl =
        Uri.parse('${Global.getNotificationsEndpoint}?username=$username');

    var response = await http.get(getNotificationUrl);

    if (response.statusCode == 200) {
      List notifications = jsonDecode(response.body) as List;
      return notifications;
    } else {
      return null;
    }
  }

  //Current working code

  Future<List<PortfolioManagerDto>> getPortfolioManagers() async {
    List<PortfolioManagerDto> list = [];
    var managers = await LocalStorageService().getPortfolioManagers();

    for (var item in managers) {
      PortfolioManagerDto manager = PortfolioManagerDto.fromMap(item);
      list.add(manager);
    }

    return list;
  }
}
