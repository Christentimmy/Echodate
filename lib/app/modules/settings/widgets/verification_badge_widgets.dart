import 'dart:io';
import 'package:echodate/app/controller/verification_controller.dart';
import 'package:echodate/app/modules/settings/controller/badge_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VerificationBadgeButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const VerificationBadgeButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BuildIdSelectionStep extends StatelessWidget {
  BuildIdSelectionStep({super.key});

  final _badgeController = Get.find<BadgeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Text(
          'Select Your ID Type',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the identification document you wish to verify with',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Obx(() {
          final idTypes = _badgeController.idTypes;
          RxString selectedIdType = _badgeController.selectedIdType;
          return Expanded(
            child: ListView.builder(
              itemCount: idTypes.length,
              itemBuilder: (context, index) {
                final idType = idTypes[index];
                return Obx(() {
                  final isSelected = idType['id'] == selectedIdType.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () {
                        selectedIdType.value = idType['id'] ?? "";
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          color: isSelected
                              ? Colors.orange.shade50
                              : Colors.transparent,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              idType['name']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).primaryColor,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () => ElevatedButton(
            onPressed: _badgeController.selectedIdType.value.isNotEmpty
                ? _badgeController.nextStep
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildFrontIdUploadStep extends StatelessWidget {
  BuildFrontIdUploadStep({super.key});

  final _badgeController = Get.find<BadgeController>();

  @override
  Widget build(BuildContext context) {
    final selectedIdName = _badgeController.idTypes.firstWhere((idType) =>
        idType['id'] == _badgeController.selectedIdType.value)['name'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _badgeController.currentStep > 0
            ? InkWell(
                onTap: _badgeController.prevStep,
                child: const Icon(Icons.arrow_back),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        Text(
          'Upload Front of $selectedIdName',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please upload a clear image of the front side of your $selectedIdName',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showImageSourceOptions(_badgeController.frontIdImage);
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Obx(
                () => _badgeController.frontIdImage.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _badgeController.frontIdImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap to upload front of $selectedIdName',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => VerificationBadgeButton(
            onPressed: _badgeController.frontIdImage.value != null
                ? _badgeController.nextStep
                : null,
            text: "Continue",
          ),
        ),
      ],
    );
  }
}

class BuildBackIdUploadStep extends StatelessWidget {
  BuildBackIdUploadStep({super.key});

  final _badgeController = Get.find<BadgeController>();

  @override
  Widget build(BuildContext context) {
    final selectedIdName = _badgeController.idTypes.firstWhere((idType) =>
        idType['id'] == _badgeController.selectedIdType.value)['name'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _badgeController.currentStep > 0
            ? InkWell(
                onTap: _badgeController.prevStep,
                child: const Icon(Icons.arrow_back),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        Text(
          'Upload Back of $selectedIdName',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please upload a clear image of the back side of your $selectedIdName',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Obx(
          () => Expanded(
            child: GestureDetector(
              onTap: () {
                _showImageSourceOptions(_badgeController.backIdImage);
                print(_badgeController.backIdImage.value?.path);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: _badgeController.backIdImage.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _badgeController.backIdImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap to upload back of $selectedIdName',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => VerificationBadgeButton(
            onPressed: _badgeController.backIdImage.value != null
                ? _badgeController.nextStep
                : null,
            text: "Continue",
          ),
        ),
      ],
    );
  }
}

class BuildReviewStep extends StatelessWidget {
  BuildReviewStep({super.key});

  final _badgeController = Get.find<BadgeController>();
  final _verificationController = Get.find<VerificationController>();

  @override
  Widget build(BuildContext context) {
    final selectedIdName = _badgeController.idTypes.firstWhere((idType) =>
        idType['id'] == _badgeController.selectedIdType.value)['name'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _badgeController.currentStep > 0
            ? InkWell(
                onTap: _badgeController.prevStep,
                child: const Icon(Icons.arrow_back),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        const Text(
          'Review & Submit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please review your verification details before submission',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You\'ve selected $selectedIdName as your verification document',
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'ID Front',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.file(
                  _badgeController.frontIdImage.value!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ID Back',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.file(
                  _badgeController.backIdImage.value!,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image);
                  },
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selfie',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.file(
                  _badgeController.selfieImage.value!,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => VerificationBadgeButton(
            onPressed: () async {
              if (_verificationController.isloading.value) {
                return;
              }
              final front = _badgeController.frontIdImage.value;
              final back = _badgeController.backIdImage.value;
              final selfie = _badgeController.selfieImage.value;
              if (front == null) {
                CustomSnackbar.showErrorSnackBar(
                  "Please upload your ID front image.",
                );
                return;
              }
              if (back == null) {
                CustomSnackbar.showErrorSnackBar(
                  "Please upload your ID back image.",
                );
                return;
              }
              if (selfie == null) {
                CustomSnackbar.showErrorSnackBar("Please upload your selfie.");
                return;
              }
              await _verificationController.uploadVerificationFiles(
                idFront: front,
                idBack: back,
                selfie: selfie,
              );
            },
            text: _verificationController.isloading.value
                ? "Processing..."
                : "Submit for Verification",
          ),
        ),
      ],
    );
  }
}

class BuildSelfieStep extends StatelessWidget {
  BuildSelfieStep({super.key});

  final _badgeController = Get.find<BadgeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _badgeController.currentStep > 0
            ? InkWell(
                onTap: _badgeController.prevStep,
                child: const Icon(Icons.arrow_back),
              )
            : const SizedBox.shrink(),
        const SizedBox(height: 10),
        const Text(
          'Take a Selfie',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please take a clear selfie of your face for identity verification',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _badgeController.selectImage(
                imageSource: ImageSource.camera,
                image: _badgeController.selfieImage,
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Obx(
                () => _badgeController.selfieImage.value != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _badgeController.selfieImage.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tap to take a selfie',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => VerificationBadgeButton(
            onPressed: _badgeController.selfieImage.value != null
                ? _badgeController.nextStep
                : null,
            text: "Continue",
          ),
        ),
      ],
    );
  }
}

void _showImageSourceOptions(Rxn<File?> image) {
  final badgeController = Get.find<BadgeController>();
  showModalBottomSheet(
    context: Get.context!,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  badgeController.selectImage(
                    imageSource: ImageSource.camera,
                    image: image,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  badgeController.selectImage(
                    imageSource: ImageSource.gallery,
                    image: image,
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
