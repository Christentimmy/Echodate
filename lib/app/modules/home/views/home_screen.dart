import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DatingAppUI extends StatelessWidget {
  final List<String> storyImages = [
    'https://randomuser.me/api/portraits/women/1.jpg',
    'https://randomuser.me/api/portraits/women/2.jpg',
    'https://randomuser.me/api/portraits/men/3.jpg',
    'https://randomuser.me/api/portraits/men/4.jpg',
    'https://randomuser.me/api/portraits/men/5.jpg',
  ];

  final List<Map<String, String>> profiles = [
    {
      "name": "Sara Williams",
      "location": "California, USA (54 km)",
      "image": "assets/images/pp.jpg",
      "match": "70% Match"
    },
    {
      "name": "Emma Brown",
      "location": "New York, USA (30 km)",
      "image": "assets/images/pp.jpg",
      "match": "85% Match"
    },
    {
      "name": "Sophia Davis",
      "location": "Texas, USA (10 km)",
      "image": "assets/images/pp.jpg",
      "match": "90% Match"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/ECHODATE.png",
                    width: Get.width * 0.2,
                    height: 30,
                    fit: BoxFit.fitWidth,
                  ),
                  const Row(
                    children: [
                      Icon(Icons.notifications, color: Colors.black),
                      SizedBox(width: 10),
                      Icon(Icons.chat, color: Colors.black),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: storyImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(storyImages[index]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          [
                            'My Story',
                            'Selena',
                            'Clara',
                            'Fabian',
                            "Tope"
                          ][index],
                          style: const TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            CustomSlidingSegmentedControl<int>(
              fixedWidth: MediaQuery.of(context).size.width / 2.2,
              innerPadding: const EdgeInsets.all(3),
              children: const {
                1: Text(
                  'Search Partners',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 39, 28, 6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                2: Text(
                  'Watch Live',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 39, 28, 6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              },
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(22),
              ),
              thumbDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: const Offset(
                      0.0,
                      2.0,
                    ),
                  ),
                ],
              ),
              onValueChanged: (int value) {},
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Swiping Cards
                  CardSwiper(
                    cardBuilder: (
                      context,
                      index,
                      horizontalOffsetPercentage,
                      verticalOffsetPercentage,
                    ) {
                      return TinderCard(
                        profile: profiles[index],
                      );
                    },
                    cardsCount: profiles.length,
                  ),

                  // Fixed Like/Dislike/Favorite Buttons
                  Positioned(
                    bottom: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _actionButton(FontAwesomeIcons.xmark, Colors.grey),
                        const SizedBox(width: 20),
                        _actionButton(
                          FontAwesomeIcons.solidHeart,
                          Colors.orange,
                        ),
                        const SizedBox(width: 20),
                        _actionButton(
                          FontAwesomeIcons.star,
                          Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 30),
        onPressed: () {},
      ),
    );
  }
}

class TinderCard extends StatelessWidget {
  final Map<String, String> profile;

  const TinderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Profile Card with Background Image
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 3, color: Colors.orange),
            image: DecorationImage(
              image: AssetImage(profile["image"]!),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Linear Gradient Overlay (Light at top, Dark at bottom)
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 1.0],
              colors: [
                Colors.black.withOpacity(0.1), // Light at top
                Colors.black.withOpacity(0.8), // Darker at bottom
              ],
            ),
          ),
        ),

        // Match Percentage Badge
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width * 0.32,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(
              profile["match"]!,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // User Details (Name, Location)
        Positioned(
          bottom: Get.height * 0.12,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile["name"]!,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                profile["location"]!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
