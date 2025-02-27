import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';

class PreferenceSettingScreen extends StatefulWidget {
  const PreferenceSettingScreen({super.key});

  @override
  State<PreferenceSettingScreen> createState() =>
      _PreferenceSettingScreenState();
}

class _PreferenceSettingScreenState extends State<PreferenceSettingScreen> {
  bool showMeMen = true;
  bool showMeWomen = true;
  double distance = 50.0;
  RangeValues ageRange = const RangeValues(18, 45);
  String selectedRelationshipType = "Casual Dating";
  List<String> relationshipTypes = [
    "Casual Dating",
    "Serious Relationship",
    "Friendship",
    "Marriage"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preferences",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gender Preferences
            const Text(
              "Show Me",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Text(
                  "Men",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    activeColor: AppColors.primaryColor,
                    value: showMeMen,
                    onChanged: (value) {
                      setState(() {
                        showMeMen = value;
                      });
                    },
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "Women",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    activeColor: AppColors.primaryColor,
                    value: showMeWomen,
                    onChanged: (value) {
                      setState(() {
                        showMeWomen = value;
                      });
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            Text(
              "Maximum Distance (${distance.toInt()} km)",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              activeColor: AppColors.primaryColor,
              value: distance,
              min: 1,
              max: 100,
              divisions: 99,
              onChanged: (value) {
                setState(() {
                  distance = value;
                });
              },
            ),
            const Divider(),

            // Age Range Preference
            Text(
              "Age Range (${ageRange.start.toInt()} - ${ageRange.end.toInt()})",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RangeSlider(
              activeColor: AppColors.primaryColor,
              values: ageRange,
              min: 18,
              max: 60,
              divisions: 42,
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
            const Divider(),

            // Relationship Type Preference
            // const Text(
            //   "Looking For",
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(
            //     border: const OutlineInputBorder(),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: BorderSide(color: AppColors.primaryColor),
            //     ),
            //   ),
            //   value: selectedRelationshipType,
            //   items: relationshipTypes.map((String type) {
            //     return DropdownMenuItem<String>(
            //       value: type,
            //       child: Text(type),
            //     );
            //   }).toList(),
            //   onChanged: (newValue) {
            //     setState(() {
            //       selectedRelationshipType = newValue!;
            //     });
            //   },
            // ),
            const Spacer(),

            // Save Button
            CustomButton(
              ontap: () {},
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
