import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/favourtie/widgets/favourite_screen_wigets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isMatchesListFetched.value) {
        _userController.getMatches();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Matches",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_alt_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Obx(() {
                if (_userController.isloading.value) {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                } else if (_userController.matchesList.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No match found.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: GridView.builder(
                      itemCount: _userController.matchesList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemBuilder: (context, index) {
                        final matchUserModel =
                            _userController.matchesList[index];
                        return LikeAndMatchCard(
                          userController: _userController,
                          matchUserModel: matchUserModel,
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
