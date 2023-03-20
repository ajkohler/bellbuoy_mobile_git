class MessageDto {
  late int id;
  late String userId;
  late int schemeId;
  late String recipientId;
  late String theMessage;
  late DateTime createdDate;

  Map<String, dynamic> toMap() {
    return {
      'TheMessage': theMessage,
    };
  }
}
