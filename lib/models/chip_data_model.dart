import 'package:flutter/cupertino.dart';

class ChipData {
  final String label;
  final IconData? icon;
  final int key;

  const ChipData({
    required this.key,
    this.icon,
    required this.label,
  });
}
