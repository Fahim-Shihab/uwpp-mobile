import 'package:flutter/material.dart';

class Factory {
  final int id;
  final String nameEn;
  final String nameBn;
  final int associationId;

  Factory({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.associationId,
  });

  factory Factory.fromJson(Map<String, dynamic> json) {
    return Factory(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
      associationId: json['associationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
      'associationId': associationId,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}