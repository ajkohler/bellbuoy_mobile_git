import 'dart:convert';

import 'package:bellbuoy_mobile/dtos/email_dto.dart';
import 'package:bellbuoy_mobile/dtos/message_dto.dart';
import 'package:bellbuoy_mobile/dtos/portfolio_manager_dto.dart';
import 'package:http/http.dart' as http;

import '../classes/global.dart';
import 'local_storage_service.dart';

class ContactUsService {
  Future<int> sendEmail(String message) async {
    // get email address
    var pm = await LocalStorageService().getPMDetails();
    PortfolioManagerDto portfolioManager = PortfolioManagerDto.fromMap(pm);
    // portfolioManager.email = 'michael@codeflux.co.za';

    var messageDto = MessageDto();
    messageDto.theMessage = message;

    EmailDto emailDto = EmailDto();
    emailDto.message = messageDto;
    emailDto.userEmailAddress = portfolioManager.email;
    emailDto.userFirstName = await LocalStorageService().firstname();
    emailDto.userLastName = await LocalStorageService().surname();
    emailDto.portfolioMngrEmail = portfolioManager.email;
    emailDto.portfolioMngrFistname = portfolioManager.name.split(' ')[0];
    emailDto.portfolioMngrLastName = portfolioManager.name.split(' ')[1];
    emailDto.schemeName = await LocalStorageService().schemeName();

    var url = Uri.parse('${Global.adminUri}EmailMessageMobile');
    String jsonString = json.encode(emailDto.toMap());

    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonString);
    return response.statusCode;
  }
}
