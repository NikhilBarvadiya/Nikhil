// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget CommonChip({
  void Function()? onTap,
  dynamic backgroundColor,
  dynamic chipColor,
  dynamic label,
  dynamic icon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(right: 5, left: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: chipColor),
          const SizedBox(width: 8),
          Text(label ?? '', style: TextStyle(color: chipColor, fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}
