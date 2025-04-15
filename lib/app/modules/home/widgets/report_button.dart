import 'package:flutter/material.dart';

class ReportButton extends StatelessWidget {
  final VoidCallback onTap;

  const ReportButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.flag, color: Colors.white),
        label: const Text("Report"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: onTap,
      ),
    );
  }
}