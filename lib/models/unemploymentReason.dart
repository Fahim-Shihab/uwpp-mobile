import 'package:flutter/material.dart';

class UnemploymentReason {
  final int id;
  final String nameEn;
  final String nameBn;
  final String shortNameEn;
  final String shortNameBn;

  UnemploymentReason({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.shortNameEn,
    required this.shortNameBn,
  });

  factory UnemploymentReason.fromJson(Map<String, dynamic> json) {
    return UnemploymentReason(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
      shortNameEn: json['shortNameEn'],
      shortNameBn: json['shortNameBn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
      'shortNameEn': shortNameEn,
      'shortNameBn': shortNameBn,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? shortNameBn
        : shortNameEn;
  }
}
