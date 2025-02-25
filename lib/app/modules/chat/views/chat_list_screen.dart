import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> activeFriends = [
    {
      'name': 'Alice',
      'image': 'https://randomuser.me/api/portraits/women/1.jpg'
    },
    {'name': 'Bob', 'image': 'https://randomuser.me/api/portraits/women/2.jpg'},
    {
      'name': 'Charlie',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg'
    },
    {'name': 'Diana', 'image': 'https://randomuser.me/api/portraits/men/4.jpg'},
    {
      'name': 'Timmy',
      'image': 'https://randomuser.me/api/portraits/men/30.jpg'
    },
  ];

  // Dummy data for chat list
  final List<Map<String, String>> chatList = [
    {
      'name': 'Alice',
      'message': 'Hey! How are you?',
      'time': '10:00 AM',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg'
    },
    {
      'name': 'Bob',
      'message': 'See you later!',
      'time': '9:30 AM',
      'image': 'https://randomuser.me/api/portraits/women/20.jpg'
    },
    {
      'name': 'Charlie',
      'message': 'What\'s up?',
      'time': 'Yesterday',
      'image': 'https://randomuser.me/api/portraits/women/86.jpg'
    },
    {
      'name': 'Diana',
      'message': 'Call me.',
      'time': '2 days ago',
      'image': 'https://randomuser.me/api/portraits/women/15.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Active Friends Section
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeFriends.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                          activeFriends[index]['image']!,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(activeFriends[index]['name']!),
                    ],
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          // Chat List Section
          Expanded(
            child: ListView.builder(
              itemCount: chatList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(chatList[index]['image']!),
                  ),
                  title: Text(chatList[index]['name']!),
                  subtitle: Text(chatList[index]['message']!),
                  trailing: Text(chatList[index]['time']!),
                  onTap: () {
                    // Navigate to chat screen
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
