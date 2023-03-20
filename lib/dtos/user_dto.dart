class UserDto {
  final int id;
  final String token;
  final String firstName;
  final String surname;
  final String email;
  final String username;
  final String userId;
  final int schemeId;
  final int branchId;
  final String schemeName;

  // final String? clientId;
  // final int? agentId;

  UserDto(this.userId, this.token, this.firstName, this.surname, this.email,
      this.username, this.id, this.schemeId, this.branchId, this.schemeName
      // this.clientId,
      // this.agentId,
      );

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'token': token,
      'firstname': firstName,
      'surname': surname,
      'email': email,
      'username': username,
      'id': id,
      'schemeId': schemeId,
      'branchId': branchId,
      'schemeName': schemeName,
      // 'clientId': clientId,
      // 'agentId': agentId,
    };
  }
}
