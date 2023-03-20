class PortfolioManagerDto {
  late String title;
  late String name;
  late String email;
  late String tel;
  late String description;

  PortfolioManagerDto(
      this.title, this.name, this.email, this.tel, this.description);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'name': name,
      'email': email,
      'tel': tel,
      'description': description,
    };
  }

  factory PortfolioManagerDto.fromMap(Map<String, dynamic> json) {
    return PortfolioManagerDto(json['title'], json['name'], json['email'],
        json['tel'], json['description']);
  }
}
