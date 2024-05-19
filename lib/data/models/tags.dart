import 'package:flutter/material.dart';

class Tagslist {
  final int? id;
  final String nametagsAr;
  final Color colortag;
  final String nametagsEn;

  Tagslist({
    this.id,
    required this.nametagsAr,
    required this.colortag,
    required this.nametagsEn,
  });
}

final List<Tagslist> tagslist = [
  Tagslist(
      id: 1,
      nametagsEn: 'Digital Currency',
      colortag: Colors.red,
      nametagsAr: 'العملة الرقمية'),
  Tagslist(
      id: 1,
      nametagsEn: 'Innovation',
      colortag: Colors.blue,
      nametagsAr: 'ابتكار'),
  Tagslist(
      id: 1, nametagsEn: 'Sport', colortag: Colors.green, nametagsAr: 'رياضة'),
  Tagslist(id: 1, nametagsEn: 'Art', colortag: Colors.yellow, nametagsAr: 'فن'),
  Tagslist(
      id: 1, nametagsEn: 'Movie', colortag: Colors.white, nametagsAr: 'فيلم'),
  Tagslist(
      id: 1,
      nametagsEn: 'Virology',
      colortag: Colors.black,
      nametagsAr: 'علم الفيروسات'),
];
