import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/controller/pick_hobbies_controller.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickHobbiesScreen extends StatefulWidget {
  final VoidCallback? callback;
  const PickHobbiesScreen({super.key, this.callback});

  @override
  State<PickHobbiesScreen> createState() => _PickHobbiesScreenState();
}

class _PickHobbiesScreenState extends State<PickHobbiesScreen> {
  final _userController = Get.find<UserController>();
  final _pickHobController = Get.put(PickHobbiesController());
  RxString searchedText = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  "assets/images/ECHODATE.png",
                  width: Get.width * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),

              // Title
              const Text(
                "Pick your interests...",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Search Box
              // TextField(
              //   onChanged: (value) {
              //     searchedText.value = value;
              //   },
              //   decoration: InputDecoration(
              //     hintText: "Search",
              //     prefixIcon: const Icon(Icons.search),
              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       borderSide: BorderSide(color: Colors.grey.shade600),
              //     ),
              //   ),
              // ),
              CustomTextField(
                hintText: "Search",
                onChanged: (value) {
                  searchedText.value = value;
                },
                prefixIcon: Icons.search,
              ),
              const SizedBox(height: 5),

              // Subtext
              Text(
                "You should select at least 5 interests",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),

              // Interests Grid
              Obx(() {
                final interests = _pickHobController.interests;

                if (searchedText.isNotEmpty) {
                  final mapHobList = interests.where(
                    (e) {
                      String value = e["label"] ?? "";
                      return value
                          .toLowerCase()
                          .contains(searchedText.toLowerCase());
                    },
                  );
                  if (mapHobList.isNotEmpty) {
                    return Expanded(
                      flex: 6,
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: mapHobList.map((interest) {
                            bool isSelected =
                                _pickHobController.selectedInterests.contains(
                              interest["label"],
                            );
                            return buildSelectiveCards(
                              interest: interest,
                              isSelected: isSelected,
                              onTap: () {
                                _pickHobController
                                    .toggleSelection(interest["label"]!);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                }
                return Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: interests.map((interest) {
                        bool isSelected =
                            _pickHobController.selectedInterests.contains(
                          interest["label"],
                        );
                        return buildSelectiveCards(
                          interest: interest,
                          isSelected: isSelected,
                          onTap: () {
                            _pickHobController
                                .toggleSelection(interest["label"]!);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
              const Spacer(),
              CustomButton(
                ontap: () async {
                  if (widget.callback != null ||
                      _pickHobController.selectedInterests.length >= 5) {
                    await _userController.updateHobbies(
                      hobbies: _pickHobController.selectedInterests,
                      callback: widget.callback,
                    );
                  } else {
                    CustomSnackbar.showErrorSnackBar("pick 5 interest cards");
                  }
                },
                child: Obx(
                  () => _userController.isloading.value
                      ? const Loader()
                      : const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
