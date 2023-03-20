import 'package:bellbuoy_mobile/services/local_storage_service.dart';

class User {
  static final User _user = User._internal();

  factory User() {
    return _user;
  }

  String? firstName;
  String? surname;
  String? email;
  int? _schemeId;

  // Creating the getter method
  // to get input from Field/Property
  Future<String> get fullName async {
    firstName ??= await LocalStorageService().firstname();
    surname ??= await LocalStorageService().surname();
    return '$firstName $surname';
  }

  Future<String> get displayName async {
    firstName ??= await LocalStorageService().firstname();
    return firstName ?? "";
  }

  Future<String> get emailAddress async {
    email ??= await LocalStorageService().emailAddress();
    return email.toString();
  }

  Future<int> get schemeId async {
    _schemeId ??= await LocalStorageService().schemeId();
    return _schemeId as int;
  }

  User._internal();
}
