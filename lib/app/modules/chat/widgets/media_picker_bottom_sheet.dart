import 'package:echodate/app/modules/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';

class MediaPickerBottomSheet extends StatelessWidget {
  final ChatController controller;

  const MediaPickerBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionTile(
            title: "Send Image",
            onTap: () async {
              await controller.mediaController.pickImageFromGallery();
              Navigator.pop(context);
            },
            bgColor: Colors.orange,
            iconColor: Colors.white,
            icon: Icons.image,
          ),
          const SizedBox(height: 15),
          _buildOptionTile(
            title: "Send Video",
            onTap: () async {
              await controller.mediaController.pickVideoFromGallery();
              Navigator.pop(context);
            },
            bgColor: Colors.green,
            iconColor: Colors.white,
            icon: Icons.video_camera_back_sharp,
          ),
          const SizedBox(height: 15),
          _buildOptionTile(
            title: "Send Audio",
            onTap: () async {
              await controller.audioController.startRecording();
              Navigator.pop(context);
            },
            bgColor: Colors.deepPurpleAccent,
            iconColor: Colors.white,
            icon: Icons.audiotrack_sharp,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  ListTile _buildOptionTile({
    required String title,
    required VoidCallback onTap,
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bgColor,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}
