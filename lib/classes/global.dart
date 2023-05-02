class Global {
  static final Global _global = Global._internal();

  factory Global() {
    return _global;
  }

  static const bool live = false;

  static const String schemeUri = "https://adminzoneapi.bellbuoy.co.za/";
  static const String usersUri = "https://clientzoneapi.bellbuoy.co.za/";
  static const String documentsUri = "https://docapi.bellbuoy.co.za/";
  static const String adminUri = "https://adminzoneapi.bellbuoy.co.za/";

  static const String invoiceUri =
      "https://statementapi.bellbuoy.co.za/buildpdf.aspx";

  static const String tokenEndpoint = "${schemeUri}token";
  static const String getUserDetailsByTokenEndpoint =
      "$schemeUri/api/account/GetLoggedInUserMobile";
  static const String localHostUrl="http://10.0.2.2:10938/";
  static const String getGovernBodyEndpoint="${adminUri}api/Approver/IsAnApproverMobile";

  // Documents
  static const String getDocumentsEndpoint =
      "${documentsUri}api/Documents/GetDocuments";
  static const String getDocumentsByIdEndpoint = "${documentsUri}api/Documents";

  // Scheme Details
  static const String getSchemeDetailsEndPoint = "${adminUri}api/schemes";
  static const String getChairPersonEndpoint =
      "${usersUri}api/Clients/GetChairpersonBySchemeId";
  static const String getLeadMembersEndpoint =
      "${usersUri}api/Clients/GetLeadMembersBySchemeId";
  static const String getPortfolioManagersEndpoint =
      "${adminUri}api/Schemes/GetPortfolioManagersPerSchemeIdMobile";
  static const String getManagerDescriptionUrl =
      "${usersUri}api/Agent/GetUserDescriprionByEmail";

  //Notification
  static const String getNotificationsEndpoint =
      "${adminUri}notify/GetNotifications";
  static const String saveNotificationToken =
      "${adminUri}notify/saveDeviceToken";
  static const String getMessageDeleteEndpoint=
      "${adminUri}notify/messageUserDelete";

  Global._internal();
}
