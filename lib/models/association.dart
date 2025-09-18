import 'package:flutter/material.dart';

class Association {
  final int id;
  final String code;
  final String nameEn;
  final String nameBn;
  final bool active;
  final bool? deleted;

  Association({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameBn,
    required this.active,
    this.deleted,
  });

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      id: json['id'],
      code: json['code'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
      active: json['active'],
      deleted: json['deleted'],
    );
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}
