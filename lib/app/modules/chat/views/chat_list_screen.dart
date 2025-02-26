import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({super.key});
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
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Online",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: activeFriends.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                            activeFriends[index]['image']!,
                          ),
                        ),
                        const Positioned(
                          top: 2,
                          right: 2,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text(
              "My Chats",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            // Chat List Section
            Expanded(
              child: ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: CachedNetworkImageProvider(
                            chatList[index]['image']!,
                          ),
                        ),
                        const Positioned(
                          top: 1,
                          right: 1,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.green,
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text(
                      chatList[index]['name']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      chatList[index]['message']!,
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: CircleAvatar(
                      radius: 13,
                      backgroundColor: AppColors.primaryColor,
                      child: const Text(
                        "25",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
