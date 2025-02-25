import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/live/views/watch_live_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => WatchLiveScreen());
                        },
                        child: const Icon(
                          FontAwesomeIcons.hive,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.notifications, color: Colors.black),
                      const SizedBox(width: 10),
                      const Icon(Icons.menu_rounded, color: Colors.black),
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
                  return StoryCard(
                    storyImages: storyImages,
                    index: index,
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
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
                      return InkWell(
                        onTap: () {
                          Get.to(() => const TinderCardDetails());
                        },
                        child: TinderCard(profile: profiles[index]),
                      );
                    },
                    cardsCount: profiles.length,
                  ),

                  Positioned(
                    bottom: Get.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        actionButton(
                          FontAwesomeIcons.xmark,
                          Colors.white,
                          false,
                        ),
                        const SizedBox(width: 20),
                        actionButton(
                          FontAwesomeIcons.solidHeart,
                          Colors.orange,
                          true,
                        ),
                        const SizedBox(width: 20),
                        actionButton(
                          Icons.star_border,
                          Colors.white,
                          false,
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
}
