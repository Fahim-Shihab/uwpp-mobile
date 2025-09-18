import 'package:flutter/material.dart';

class UnemploymentReason {
  final int id;
  final String nameEn;
  final String nameBn;

  UnemploymentReason({
    required this.id,
    required this.nameEn,
    required this.nameBn,
  });

  factory UnemploymentReason.fromJson(Map<String, dynamic> json) {
    return UnemploymentReason(
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