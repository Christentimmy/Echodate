import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget actionButton(
  IconData icon,
  Color color,
  bool isCenter,
) {
  return Container(
    height: isCenter ? 70 : 55,
    width: isCenter ? 70 : 55,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isCenter ? Colors.white : Colors.white.withOpacity(0.8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 6,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Icon(
      icon,
      color: color,
      size: 25,
    ),
  );
}

class AnimatedSwitcherWidget extends StatelessWidget {
  const AnimatedSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 1.0],
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),
        Positioned(
          top: 20,
          right: 10,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primaryColor,
            ),
            child: const Icon(
              FontAwesomeIcons.wallet,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width * 0.32,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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

class StoryCard extends StatelessWidget {
  final int index;
  const StoryCard({
    super.key,
    required this.storyImages,
    required this.index,
  });

  final List<String> storyImages;

  @override
  Widget build(BuildContext context) {
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
            ['My Story', 'Selena', 'Clara', 'Fabian', "Tope"][index],
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
