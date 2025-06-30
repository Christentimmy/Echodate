import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/controller/pick_hobbies_controller.dart';
import 'package:echodate/app/modules/profile/views/edit_profile_screen.dart';
import 'package:echodate/app/modules/profile/widgets/profile_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userController = Get.find<UserController>();
  final _pickHobController = Get.put(PickHobbiesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_userController.isStatFetched.value) {
        await _userController.getProfileStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          await _userController.getUserDetails();
          await _userController.getProfileStats();
        },
        child: CustomScrollView(
          slivers: [
            // Profile Header with Image
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.37,
              pinned: true,
              backgroundColor: Colors.orangeAccent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade50),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.grey.shade50),
                  onPressed: () {
                    Get.to(() => EditProfileScreen());
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.orange.shade300,
                            Colors.orange.shade500,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() {
                            final model = _userController.userModel.value;
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 4),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    model?.avatar ?? "",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                          const Text(
                            'Alex Johnson',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(() {
                            final model = _userController.userModel.value;
                            return Text(
                              '${calculateAge(model?.dob)} years old',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Profile Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats
                    Obx(() {
                      final model = _userController.userProfileStat.value;
                      if (_userController.isloading.value || model == null) {
                        return buildStatShimmerPlaceholder();
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Photos',
                              (model.totalPhotos + 1).toString(),
                              Icons.photo_library,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Matches',
                              (model.totalMatches).toString(),
                              Icons.favorite,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Likes',
                              (model.totalSwipes).toString(),
                              Icons.thumb_up,
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 32),

                    // About Section
                    _buildSectionHeader('About Me'),
                    const SizedBox(height: 14),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Obx(
                          () => Text(
                            _userController.userModel.value?.bio ?? "",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              height: 1.6,
                            ),
                          ),
                        )),
                    const SizedBox(height: 32),
                    _buildSectionHeader('My Interests'),
                    const SizedBox(height: 16),
                    _buildAllInterestWidget(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Looking For'),
                    const SizedBox(height: 16),
                    _buildRelationshipPreference(),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Obx _buildRelationshipPreference() {
    return Obx(() {
      final model = _userController.userModel.value;
      final minAge = model?.preferences?.ageRange?[0] ?? 0;
      final maxAge = model?.preferences?.ageRange?[1] ?? 0;
      final distance = model?.preferences?.maxDistance ?? 0;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  model?.relationshipPreference ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ages $minAge-$maxAge • Within $distance km',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    });
  }

  Obx _buildAllInterestWidget() {
    return Obx(() {
      List? hobbies = _userController.userModel.value?.hobbies;
      if (hobbies == null || hobbies.isEmpty) {
        return const SizedBox.shrink();
      }
      return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: hobbies.map(
            (interest) {
              final index = _pickHobController.interests.indexWhere(
                (e) => e["label"]?.toLowerCase() == interest.toLowerCase(),
              );
              String emoji = _pickHobController.interests[index]["emoji"] ?? "";
              return _buildInterestChip(
                interest,
                emoji,
              );
            },
          ).toList());
    });
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String interest, String icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(icon, color: Colors.orange, size: 16),
          Text(
            "$icon ",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 8),
          Text(
            interest,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
