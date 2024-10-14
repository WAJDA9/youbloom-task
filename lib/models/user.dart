import 'dart:convert';

class AppUser {
  String? phoneNumber;

  AppUser({
    this.phoneNumber,
  });

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {"phoneNumber": phoneNumber};
}
