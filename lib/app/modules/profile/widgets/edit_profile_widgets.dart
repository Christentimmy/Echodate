import 'dart:io';
import 'package:echodate/app/controller/timer_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/profile/controller/edit_profile_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class ProfileImage extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final bool isLarge;
  final VoidCallback onPickImage;
  final VoidCallback onRemove;
  final int index;
  ProfileImage({
    super.key,
    required this.imageFile,
    required this.imageUrl,
    required this.index,
    required this.onPickImage,
    required this.onRemove,
    this.isLarge = false,
  });

  final _editProfileController = Get.find<EditProfileController>();
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;

    return GestureDetector(
      onTap: onPickImage,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
        width: isLarge ? screenWidth * 0.585 : screenWidth * 0.28,
        height: isLarge ? screenHeight * 0.319 : screenHeight * 0.147,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
          border: isLarge ? Border.all(color: Colors.blue, width: 2) : null,
          image: _buildImage(),
        ),
        child: Stack(
          children: [
            Obx(() {
              final deletedIndex = _editProfileController.deletedIndex.value;
              final isDeleting = _userController.isloading.value;
              final isLoading = deletedIndex == index && isDeleting;
              if (isLoading) {
                return const Positioned(
                  top: 5,
                  right: 5,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  ),
                );
              } else if (imageFile != null ||
                  (imageUrl != null && imageUrl!.isNotEmpty)) {
                return Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  DecorationImage _buildImage() {
    if (imageFile != null) {
      return DecorationImage(
        image: FileImage(imageFile!),
        fit: BoxFit.cover,
      );
    }

    if (imageUrl?.isNotEmpty == true) {
      return DecorationImage(
        image: NetworkImage(imageUrl!),
        fit: BoxFit.cover,
      );
    }

    return const DecorationImage(
      image: AssetImage("assets/images/placeholder1.png"),
      fit: BoxFit.cover,
    );
  }
}

class BuildPictureSection extends StatelessWidget {
  BuildPictureSection({super.key});

  final _userController = Get.find<UserController>();
  final _editPontroller = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Obx(() {
              final userModel = _userController.userModel.value;
              return ProfileImage(
                imageUrl: userModel?.avatar,
                imageFile: _editPontroller.profileImage.value,
                isLarge: true,
                index: 8,
                onPickImage: () async {
                  await _editPontroller.selectImage(8, isProfile: true);
                },
                onRemove: () {},
              );
            }),
            SizedBox(width: Get.width * 0.02),
            Obx(
              () => Column(
                children: [
                  ...buildTopImages(),
                ],
              ),
            ),
          ],
        ),
        Obx(() => buildBottomImages()),
      ],
    );
  }

  List<Widget> buildTopImages() {
    return List.generate(2, (i) {
      final userModel = _userController.userModel.value ?? UserModel();
      final images = _editPontroller.images;
      final photos = userModel.photos ?? [];
      final imageUrl = i < photos.length ? photos[i] : null;
      final imageFile = i < images.length ? images[i] : null;

      return Padding(
        padding: EdgeInsets.only(bottom: Get.height * 0.01),
        child: ProfileImage(
          imageUrl: imageUrl,
          imageFile: imageFile,
          index: i,
          onPickImage: () => _editPontroller.selectImage(i),
          onRemove: () => _editPontroller.removeImage(i),
        ),
      );
    });
  }

  Widget buildBottomImages() {
    final userModel = _userController.userModel.value ?? UserModel();
    final photos = userModel.photos ?? [];
    final images = _editPontroller.images;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final imgIndex = i + 2;
        final imageUrl = imgIndex < photos.length ? photos[imgIndex] : null;
        final imageFile = imgIndex < images.length ? images[imgIndex] : null;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
          child: ProfileImage(
            imageUrl: imageUrl,
            imageFile: imageFile,
            index: imgIndex,
            onPickImage: () => _editPontroller.selectImage(imgIndex),
            onRemove: () => _editPontroller.removeImage(imgIndex),
          ),
        );
      }),
    );
  }
}

class BuildGenderSelectField extends StatelessWidget {
  BuildGenderSelectField({super.key});

  final _editProfileController = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        value: _editProfileController.gender.value,
        onChanged: (value) {
          _editProfileController.gender.value = value!;
        },
        items: ['Male', 'Female', 'Other'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

class BuildSaveButton extends StatelessWidget {
  BuildSaveButton({super.key});

  final _editProfileController = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      ontap: () async {
        if (_editProfileController.isSaving.value) return;
        await _editProfileController.saveProfile();
      },
      child: Obx(
        () => _editProfileController.isSaving.value
            ? const CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class OtpVerificationBottomSheet extends StatefulWidget {
  final String contactType; // 'email' or 'phone'
  final String contactValue; // The actual email or phone number
  final Function(String) onOtpSubmitted;
  final Function() onResendOtp;

  const OtpVerificationBottomSheet({
    super.key,
    required this.contactType,
    required this.contactValue,
    required this.onOtpSubmitted,
    required this.onResendOtp,
  });

  /// Shows the OTP verification bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String contactType,
    required String contactValue,
    required Function(String) onOtpSubmitted,
    required Function() onResendOtp,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OtpVerificationBottomSheet(
        contactType: contactType,
        contactValue: contactValue,
        onOtpSubmitted: onOtpSubmitted,
        onResendOtp: onResendOtp,
      ),
    );
  }

  @override
  State<OtpVerificationBottomSheet> createState() =>
      _OtpVerificationBottomSheetState();
}

class _OtpVerificationBottomSheetState
    extends State<OtpVerificationBottomSheet> {
  final _timerController = Get.put(TimerController());
  final _editProfileController = Get.find<EditProfileController>();

  @override
  void initState() {
    super.initState();
    _timerController.startTimer();
  }

  @override
  void dispose() {
    _editProfileController.pinController.clear();
    _editProfileController.isSubmitting.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Verification Code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'We have sent a verification code to ${_editProfileController.getMaskedContact(widget.contactType == 'email', widget.contactValue)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // PIN input
              Pinput(
                length: 4,
                controller: _editProfileController.pinController,
                focusNode: _editProfileController.pinFocusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                onChanged: (_) => setState(() {}),
                showCursor: true,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 1,
                      height: 24,
                      margin: const EdgeInsets.only(bottom: 12),
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Verify button
              ElevatedButton(
                onPressed:
                    _editProfileController.pinController.text.length == 4 &&
                            !_editProfileController.isSubmitting.value
                        ? () {
                            _editProfileController.submitOtp(
                              onOtpSubmitted: widget.onOtpSubmitted,
                            );
                          }
                        : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Obx(
                  () => _editProfileController.isSubmitting.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Resend code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the code?',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  TextButton(
                    onPressed: _timerController.secondsRemaining <= 0
                        ? () {
                            _editProfileController.handleResendOtp(
                              controller: _timerController,
                              onResendOtp: widget.onResendOtp,
                            );
                          }
                        : null,
                    child: Obx(
                      () => Text(
                        _timerController.secondsRemaining <= 0
                            ? 'Resend'
                            : '${_timerController.secondsRemaining}s',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
