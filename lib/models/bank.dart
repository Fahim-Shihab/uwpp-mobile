import 'package:flutter/material.dart';

class Bank {
  final int id;
  final String nameEn;
  final String nameBn;

  Bank({
    required this.id,
    required this.nameEn,
    required this.nameBn,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}