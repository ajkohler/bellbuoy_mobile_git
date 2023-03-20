class SchemeMemberDto {
  late final String name;
  late final String title;

  SchemeMemberDto(this.name, this.title);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
    };
  }

  factory SchemeMemberDto.fromMap(Map<String, dynamic> json) {
    return SchemeMemberDto(json['name'], json['title']);
  }
}
