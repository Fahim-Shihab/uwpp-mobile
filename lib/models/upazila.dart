import 'package:flutter/material.dart';

class Upazila {
  final int id;
  final String nameEn;
  final String nameBn;
  final int districtId;

  Upazila({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.districtId,
  });

  factory Upazila.fromJson(Map<String, dynamic> json) {
    return Upazila(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
      districtId: json['districtId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
      'districtId': districtId,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}