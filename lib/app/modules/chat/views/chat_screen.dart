import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () => Get.back(),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage("assets/images/pp.jpg"),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Snow",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.lock, size: 18, color: Colors.grey),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    "Messages are end-to-end encrypted. No one outside of this chat, not even TLC, can read or listen to them.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                chatBubble(
                  text: "Hi. What's up?",
                  isSender: true,
                  time: "20/09/14 13:09",
                ),
                chatBubble(
                  text: "Hi. I'm doing great. How about u?",
                  isSender: false,
                  time: "20/09/14 13:09",
                ),
                chatBubble(
                  text: "I'm also fine. Can we hang out today?",
                  isSender: true,
                  time: "20/09/14 13:09",
                ),
                chatBubble(
                  text: "Great idea. Let's meet today.",
                  isSender: false,
                  time: "20/09/14 13:09",
                ),
              ],
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.attach_file_rounded,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildProfileSettingTiles(
                                title: "Send Image",
                                onTap: () {},
                                bgColor: Colors.orange,
                                iconColor: Colors.white,
                                icon: Icons.image,
                              ),
                              const SizedBox(height: 10),
                              _buildProfileSettingTiles(
                                title: "Send Video",
                                onTap: () {},
                                bgColor: Colors.green,
                                iconColor: Colors.white,
                                icon: Icons.video_camera_back_sharp,
                              ),
                              const SizedBox(height: 10),
                              _buildProfileSettingTiles(
                                title: "Send Audio",
                                onTap: () {},
                                bgColor: Colors.deepPurpleAccent,
                                iconColor: Colors.white,
                                icon: Icons.audiotrack_sharp,
                              ),
                              const SizedBox(height: 10),
                              _buildProfileSettingTiles(
                                title: "Send Document",
                                onTap: () {},
                                bgColor: Colors.lightBlueAccent,
                                iconColor: Colors.white,
                                icon: Icons.document_scanner,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildProfileSettingTiles({
    required String title,
    required VoidCallback onTap,
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 20,
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

  // Chat Bubble Widget
  static Widget chatBubble({
    required String text,
    required bool isSender,
    required String time,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSender ? Colors.orange : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
