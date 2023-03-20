class DocumentDto {
  late String title;
  late String name;
  late String category;
  late String path;
  late int documentCategoryId;
  late int documentTypeId;

  DocumentDto(this.name, this.title, this.path);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'title': title,
      'path': path,
    };
  }

  factory DocumentDto.fromMap(Map<String, dynamic> json) {
    return DocumentDto(json['name'], json['title'], json['path']);
  }
}
