import 'message_dto.dart';

class EmailDto {
  late String portfolioMngrEmail;
  late String portfolioMngrFistname;
  late String portfolioMngrLastName;
  late String userFirstName;
  late String userLastName;
  late String userEmailAddress;
  late String schemeName;
  late MessageDto message;

  Map<String, dynamic> toMap() {
    return {
      'PortfolioMngrEmail': portfolioMngrEmail,
      'PortfolioMngrFistname': portfolioMngrFistname,
      'PortfolioMngrLastName': portfolioMngrLastName,
      'SchemeName': schemeName,
      'UserFirstName': userFirstName,
      'UserLastName': userLastName,
      'UserEmailAddress': userEmailAddress,
      'Message': message.toMap(),
    };
  }
}
