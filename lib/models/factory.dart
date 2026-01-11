import 'package:flutter/material.dart';

class Factory {
  final int id;
  final String nameEn;
  final int parent;

  Factory({
    required this.id,
    required this.nameEn,
    required this.parent,
  });

  factory Factory.fromJson(Map<String, dynamic> json) {
    return Factory(
      id: json['id'],
      nameEn: json['nameEn'],
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'parent': parent,
    };
  }

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameEn
        : nameEn;
  }
}
