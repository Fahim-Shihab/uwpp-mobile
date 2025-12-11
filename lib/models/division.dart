import 'package:flutter/material.dart';

class Division {
  final int id;
  final String nameEn;
  final String nameBn;

  Division({required this.id, required this.nameEn, required this.nameBn});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nameEn': nameEn, 'nameBn': nameBn};
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}
