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

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  final _userController = Get.find<UserController>();
  final _pickHobController = Get.put(PickHobbiesController());

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _staggerController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _staggerAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _staggerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: Curves.easeOutQuart,
    ));

    // Start animations
    _startAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_userController.isStatFetched.value) {
        await _userController.getProfileStats();
      }
    });
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
        _scaleController.forward();
        _staggerController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          await _userController.getUserDetails();
          await _userController.getProfileStats();
          // Restart animations on refresh
          _fadeController.reset();
          _slideController.reset();
          _scaleController.reset();
          _staggerController.reset();
          _startAnimations();
        },
        child: CustomScrollView(
          slivers: [
            // Animated Profile Header with Image
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
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _fadeAnimation.value,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey.shade50),
                          onPressed: () {
                            Get.to(() => EditProfileScreen());
                          },
                        ),
                      ),
                    );
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
                      child: AnimatedBuilder(
                        animation: _fadeAnimation,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Obx(() {
                                    final model =
                                        _userController.userModel.value;
                                    return AnimatedBuilder(
                                      animation: _scaleAnimation,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _scaleAnimation.value,
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 4,
                                              ),
                                              image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                  model?.avatar ?? "",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                  const SizedBox(height: 10),
                                  Obx(() {
                                    final model =
                                        _userController.userModel.value;
                                    return Text(
                                      model?.fullName ?? "",
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 4),
                                  Obx(() {
                                    final model =
                                        _userController.userModel.value;
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Animated Profile Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Quick Stats
                    AnimatedBuilder(
                      animation: _staggerAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - _staggerAnimation.value)),
                          child: Opacity(
                            opacity: _staggerAnimation.value,
                            child: _buildAnimatedStats(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Animated About Section
                    AnimatedBuilder(
                      animation: _staggerAnimation,
                      builder: (context, child) {
                        final delayedAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _staggerController,
                          curve:
                              const Interval(0.2, 1.0, curve: Curves.easeOut),
                        ));

                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - delayedAnimation.value)),
                          child: Opacity(
                            opacity: delayedAnimation.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader('About Me'),
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? const Color.fromARGB(255, 34, 34, 34)
                                        : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Obx(
                                    () => Text(
                                      _userController.userModel.value?.bio ??
                                          "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                        color: Get.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Animated Interests Section
                    AnimatedBuilder(
                      animation: _staggerAnimation,
                      builder: (context, child) {
                        final delayedAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _staggerController,
                          curve:
                              const Interval(0.4, 1.0, curve: Curves.easeOut),
                        ));

                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - delayedAnimation.value)),
                          child: Opacity(
                            opacity: delayedAnimation.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader('My Interests'),
                                const SizedBox(height: 16),
                                _buildAnimatedInterests(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Animated Looking For Section
                    AnimatedBuilder(
                      animation: _staggerAnimation,
                      builder: (context, child) {
                        final delayedAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _staggerController,
                          curve:
                              const Interval(0.6, 1.0, curve: Curves.easeOut),
                        ));

                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - delayedAnimation.value)),
                          child: Opacity(
                            opacity: delayedAnimation.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader('Looking For'),
                                const SizedBox(height: 16),
                                _buildRelationshipPreference(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

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

  Widget _buildAnimatedStats() {
    return Obx(() {
      final model = _userController.userProfileStat.value;
      if (_userController.isloading.value || model == null) {
        return buildStatShimmerPlaceholder();
      }

      return Row(
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value.clamp(0.0, 1.0),
                  child: _buildStatCard(
                    'Photos',
                    (model.totalPhotos + 1).toString(),
                    Icons.photo_library,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 700),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value.clamp(0.0, 1.0),
                  child: _buildStatCard(
                    'Matches',
                    (model.totalMatches).toString(),
                    Icons.favorite,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value.clamp(0.0, 1.0),
                  child: _buildStatCard(
                    'Likes',
                    (model.totalSwipes).toString(),
                    Icons.thumb_up,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildAnimatedInterests() {
    return Obx(() {
      List? hobbies = _userController.userModel.value?.hobbies;
      if (hobbies == null || hobbies.isEmpty) {
        return const SizedBox.shrink();
      }

      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: hobbies.asMap().entries.map((entry) {
          final index = entry.key;
          final interest = entry.value;
          final hobbyIndex = _pickHobController.interests.indexWhere(
            (e) => e["label"]?.toLowerCase() == interest.toLowerCase(),
          );
          String emoji = hobbyIndex != -1
              ? _pickHobController.interests[hobbyIndex]["emoji"] ?? ""
              : "";

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: _buildInterestChip(interest, emoji),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Obx _buildRelationshipPreference() {
    return Obx(() {
      final model = _userController.userModel.value;
      final minAge = model?.preferences?.ageRange?[0] ?? 0;
      final maxAge = model?.preferences?.ageRange?[1] ?? 0;
      final distance = model?.preferences?.maxDistance ?? 0;

      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.9 + (0.1 * value.clamp(0.0, 1.0)),
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Container(
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
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 34, 34, 34)
            : Colors.white,
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
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 400),
            curve: Curves.bounceOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: Icon(icon, color: Colors.orange, size: 24),
              );
            },
          ),
          const SizedBox(height: 8),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: double.parse(value)),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, animatedValue, child) {
              return Text(
                animatedValue.toInt().toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? const Color.fromARGB(255, 34, 34, 34)
            : Colors.grey.shade50,
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
          Text(
            "$icon ",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 8),
          Text(
            interest,
            style: TextStyle(
              color: Get.theme.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
