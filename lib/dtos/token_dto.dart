class TokenDto {
  final String token;
  final String account;

  TokenDto(this.token, this.account);

  Map<String, dynamic> toJson() {
    return {
      'Token': token,
      'Account': account,
    };
  }
}
