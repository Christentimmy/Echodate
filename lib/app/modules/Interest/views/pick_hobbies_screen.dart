import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/widget/custom_button.dart';
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
  List<Map<String, String>> interests = [
    {"emoji": "⚽", "label": "Football"},
    {"emoji": "🌿", "label": "Nature"},
    {"emoji": "🗣️", "label": "Language"},
    {"emoji": "📸", "label": "Photography"},
    {"emoji": "🌱", "label": "Tech"},
    {"emoji": "✍️", "label": "Singing"},
    {"emoji": "🎾", "label": "Tennis"},
    {"emoji": "✍️", "label": "Writing"},
    {"emoji": "🗣️", "label": "Clubbing"},
    {"emoji": "💃", "label": "Dancing"},
    {"emoji": "✍️", "label": "Coffee"},
    {"emoji": "💉", "label": "Tattoos"},
    {"emoji": "🎣", "label": "Fishing"},
    {"emoji": "👗", "label": "Fashion"},
    {"emoji": "🏕️", "label": "Camping"},
    {"emoji": "🍳", "label": "Cooking"},
    {"emoji": "🍷", "label": "Wine"},
    {"emoji": "🧘", "label": "Meditation"},
  ];

  final _userController = Get.find<UserController>();
  List<String> selectedInterests = [];

  void toggleSelection(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              // Subtext
              Text(
                "You should select at least 5 interests",
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),

              // Interests Grid
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: interests.map((interest) {
                      bool isSelected = selectedInterests.contains(
                        interest["label"],
                      );
                      return buildSelectiveCards(
                        interest: interest,
                        isSelected: isSelected,
                        onTap: () {
                          toggleSelection(interest["label"]!);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                ontap: () async {
                  if (widget.callback != null || selectedInterests.length >= 5) {
                    await _userController.updateHobbies(
                      hobbies: selectedInterests,
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
