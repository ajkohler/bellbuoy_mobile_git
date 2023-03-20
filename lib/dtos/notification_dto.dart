class NotificationDto {
  late int id;
  late String message;
  late String date;

  NotificationDto(this.id, this.message, this.date);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'date': date,
    };
  }

  factory NotificationDto.fromMap(Map<String, dynamic> json) {
    return NotificationDto(json['id'], json['message'], json['date']);
  }
}
