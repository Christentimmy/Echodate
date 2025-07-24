import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/echocoin/views/send_coins_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class TinderCard extends StatelessWidget {
  final UserModel profile;
  const TinderCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            border: Border.all(width: 3, color: Colors.orange),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(57),
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              imageUrl: profile.avatar ?? "",
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: AppColors.primaryColor,
                  child: const SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                );
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(57),
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
        profile.plan != "free"
            ? Positioned(
                top: 20,
                right: 20,
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => SendCoinsScreen(
                        recipientName: profile.fullName ?? "",
                        recipientId: profile.id ?? "",
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.wallet,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width * 0.27,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 5,
            ),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Text(
              "${profile.matchPercentage.toString()}% Match",
              style: const TextStyle(
                fontSize: 14,
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
              Row(
                children: [
                  Text(
                    profile.fullName ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(width: 5),
                  profile.isVerified == true
                      ? const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              Text(
                profile.location?.address ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
        );
  }
}
