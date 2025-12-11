import 'package:flutter/material.dart';

class MFS {
  final int id;
  final String nameEn;
  final String nameBn;
  final int routingNumber;

  MFS({
    required this.id,
    required this.nameEn,
    required this.nameBn,
    required this.routingNumber,
  });

  factory MFS.fromJson(Map<String, dynamic> json) {
    return MFS(
      id: json['id'],
      nameEn: json['nameEn'],
      nameBn: json['nameBn'],
      routingNumber: json['routingNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameBn': nameBn,
      'routingNumber': routingNumber,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}
