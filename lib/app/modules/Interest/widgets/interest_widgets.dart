import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildSelectiveCards({
  required Map<String, String> interest,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  final isDark = Get.isDarkMode;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.orange
            : (isDark ? Colors.grey[900] : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? Colors.orange
              : (isDark ? Colors.grey[700]! : Colors.orange),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${interest["emoji"]} ",
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            interest["label"]!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.orange),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildInterestCards({required String interest}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 15,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: Colors.orange,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.15),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Text(
      interest,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    ),
  );
}
