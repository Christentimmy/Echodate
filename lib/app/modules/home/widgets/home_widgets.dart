import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

class TinderCardDetails extends StatelessWidget {
  const TinderCardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * 0.6,
              width: Get.width,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/pp.jpg",
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    height: Get.height * 0.6,
                    width: Get.width,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: Get.height * 0.08,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.grey.withOpacity(0.8),
                            child: const Icon(
                              FontAwesomeIcons.x,
                              size: 15,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
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
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Get.height * 0.02,
                    child: SizedBox(
                      height: 50,
                      width: Get.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedSmoothIndicator(
                            activeIndex: 0,
                            count: 4,
                            effect: ExpandingDotsEffect(
                              dotWidth: 10,
                              dotHeight: 10,
                              activeDotColor: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: Get.width / 4.8),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: Icon(
                              Icons.chat,
                              color: AppColors.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Text(
                  "70% match",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Column(
                        children: [
                          Text(
                            "Sara Willaims (27)",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Califonia, USA ( 54Km )"),
                        ],
                      ),
                      const Spacer(),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blueGrey.withOpacity(0.3),
                        child: const Icon(Icons.more_vert_sharp),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "About",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nisi,etium maecenas sed urna lorem ipsum dolor sit amet, consectetur adipiscing elit...",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    "Show more",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Basic Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildBasicInfoTile(
                    leading: "Gender: ",
                    title: "Male",
                  ),
                  buildBasicInfoTile(
                    leading: "Age: ",
                    title: "27 Years Old",
                  ),
                  buildBasicInfoTile(
                    leading: "Interests: ",
                    title: "Football, Clubbing, Swimming, Cooking",
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              color: AppColors.primaryColor,
              width: Get.width,
              height: Get.height * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    );
  }
}

Widget buildBasicInfoTile({
  required String title,
  required String leading,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        leading,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
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
