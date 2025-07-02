import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTimestampWidget extends StatelessWidget {
  final DateTime? createdAt;

  const MessageTimestampWidget({
    super.key,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: Text(
        createdAt != null ? DateFormat("hh:mm a").format(createdAt!) : "",
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white70,
        ),
      ),
    );
  }
}
