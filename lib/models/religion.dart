import 'package:flutter/material.dart';

class Religion {
  final int id;
  final String nameEn;
  final String nameBn;

  const Religion(this.id, this.nameEn, this.nameBn);

  String localizedName(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'bn'
        ? nameBn
        : nameEn;
  }
}

const List<Religion> religions = [
  Religion(1, "Islam", "ইসলাম"),
  Religion(2, "Hindu", "হিন্দু"),
  Religion(3, "Christianity", "খ্রিষ্টান"),
  Religion(4, "Buddhism", "বৌদ্ধ"),
  Religion(5, "Other", "অন্যান্য"),
];
