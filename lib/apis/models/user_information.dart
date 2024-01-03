import 'package:flutter/material.dart';

@immutable
class UserInformation {
  final String name;
  final String adress;
  final String phoneNumber;

  const UserInformation({
    required this.adress,
    required this.name,
    required this.phoneNumber,
  });

  const UserInformation.empty()
      : name = '',
        adress = '',
        phoneNumber = '';

  UserInformation copyWith({
    String? name,
    String? adress,
    String? phoneNumber,
  }) {
    return UserInformation(
      name: name ?? this.name,
      adress: adress ?? this.adress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
