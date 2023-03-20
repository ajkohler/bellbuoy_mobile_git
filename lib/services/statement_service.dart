import 'package:bellbuoy_mobile/services/local_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/global.dart';

class StatementService {
  Future<String> getUsername() async {
    return await LocalStorageService().username();
  }

  void openStatement(String start, String end) async {
    String username = await getUsername();
    var url = Uri.parse(
        '${Global.invoiceUri}?customerNo=$username&dateFrom=$start&dateTo=$end&format=pdf');
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
