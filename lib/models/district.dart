import 'package:flutter/material.dart';

class District {
  final int id;
  final String nameEn;
  final String nameBn;

  // final int divisionId;

  District({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    // required this.divisionId,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
      // divisionId: json['divisionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
      // 'divisionId': divisionId,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}
