import 'package:flutter/material.dart';

class CardEmployeeData {
  final String text;
  final String descriptionText;
  final String? imageUrl;
  final String? id;

  CardEmployeeData({required this.text, required this.descriptionText, this.imageUrl, this.id});
}
