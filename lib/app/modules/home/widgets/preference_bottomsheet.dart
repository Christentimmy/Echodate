
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferenceBottomSheet extends StatefulWidget {
  const PreferenceBottomSheet({super.key});

  @override
  State<PreferenceBottomSheet> createState() => _PreferenceBottomSheetState();

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PreferenceBottomSheet(),
    );
  }
}

class _PreferenceBottomSheetState extends State<PreferenceBottomSheet>
    with SingleTickerProviderStateMixin {
  final UserController _userController = Get.find<UserController>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  RxString interestedIn = "".obs;
  double distance = 0.0;
  RangeValues ageRange = const RangeValues(18, 45);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = _userController.userModel.value;
      if (user == null) return;
      
      interestedIn.value = user.interestedIn?.capitalizeFirst ?? "";
      setState(() {
        if (user.preferences != null &&
            user.preferences!.ageRange != null &&
            user.preferences!.ageRange!.length >= 2) {
          ageRange = RangeValues(
            user.preferences!.ageRange![0].toDouble(),
            user.preferences!.ageRange![1].toDouble(),
          );
        }
        distance = user.preferences?.maxDistance?.toDouble() ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> savePreferences() async {
    await _userController.updatePreference(
      minAge: ageRange.start.toInt().toString(),
      maxAge: ageRange.end.toInt().toString(),
      interestedIn: interestedIn.value,
      distance: (distance).toInt().toString(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final surfaceColor = isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF8F9FA);
    final textColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 100),
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: secondaryTextColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: AppColors.primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Preferences",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show Me Section
                          _buildSectionHeader("Show Me", Icons.people, textColor),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black12,
                              ),
                            ),
                            child: Column(
                              children: [
                                _buildGenderOption("Male", Icons.male, isDark),
                                _buildGenderOption("Female", Icons.female, isDark),
                                _buildGenderOption("Both", Icons.group, isDark),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Distance Section
                          _buildSectionHeader(
                            "Maximum Distance (${distance.toInt()} km)",
                            Icons.location_on,
                            textColor,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black12,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "1 km",
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "1000 km",
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.primaryColor,
                                    inactiveTrackColor: AppColors.primaryColor.withOpacity(0.2),
                                    thumbColor: AppColors.primaryColor,
                                    overlayColor: AppColors.primaryColor.withOpacity(0.1),
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                    trackHeight: 4,
                                  ),
                                  child: Slider(
                                    value: distance.clamp(1.0, 1000.0),
                                    min: 1,
                                    max: 1000,
                                    divisions: 50,
                                    onChanged: (value) {
                                      setState(() {
                                        distance = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Age Range Section
                          _buildSectionHeader(
                            "Age Range (${ageRange.start.toInt()} - ${ageRange.end.toInt()})",
                            Icons.calendar_today,
                            textColor,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black12,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "18 years",
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      "100 years",
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: AppColors.primaryColor,
                                    inactiveTrackColor: AppColors.primaryColor.withOpacity(0.2),
                                    thumbColor: AppColors.primaryColor,
                                    overlayColor: AppColors.primaryColor.withOpacity(0.1),
                                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                                    trackHeight: 4,
                                  ),
                                  child: RangeSlider(
                                    values: ageRange,
                                    min: 18,
                                    max: 100,
                                    divisions: 5,
                                    labels: RangeLabels(
                                      ageRange.start.toInt().toString(),
                                      ageRange.end.toInt().toString(),
                                    ),
                                    onChanged: (values) {
                                      setState(() {
                                        ageRange = values;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),

                  // Save Button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(
                      () => GestureDetector(
                        onTap: _userController.isloading.value
                            ? null
                            : savePreferences,
                        child: Container(
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _userController.isloading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    "Save Preferences",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGenderOption(String gender, IconData icon, bool isDark) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          onTap: () {
            interestedIn.value = gender;
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: interestedIn.value == gender
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: interestedIn.value == gender
                    ? AppColors.primaryColor
                    : (isDark ? Colors.white10 : Colors.black12),
                width: interestedIn.value == gender ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: interestedIn.value == gender
                      ? AppColors.primaryColor
                      : (isDark ? Colors.white70 : Colors.black54),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  gender,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: interestedIn.value == gender
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: interestedIn.value == gender
                        ? AppColors.primaryColor
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
                const Spacer(),
                if (interestedIn.value == gender)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Usage: Add this to your home screen
class PreferenceIconButton extends StatelessWidget {
  const PreferenceIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;
    
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2D2D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () => PreferenceBottomSheet.show(context),
        icon: Icon(
          Icons.tune,
          color: AppColors.primaryColor,
        ),
        tooltip: "Preferences",
      ),
    );
  }
}