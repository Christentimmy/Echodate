// import 'package:echodate/app/controller/user_controller.dart';
// import 'package:echodate/app/resources/colors.dart';
// import 'package:echodate/app/widget/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class PreferenceSettingScreen extends StatefulWidget {
//   const PreferenceSettingScreen({super.key});

//   @override
//   State<PreferenceSettingScreen> createState() =>
//       _PreferenceSettingScreenState();
// }

// class _PreferenceSettingScreenState extends State<PreferenceSettingScreen> {
//   final UserController _userController = Get.find<UserController>();

//   RxString interestedIn = "".obs;
//   double distance = 0.0;
//   RangeValues ageRange = const RangeValues(18, 45);

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final user = _userController.userModel.value;
//       if (user == null) {
//         return;
//       }
//       interestedIn.value = user.interestedIn?.capitalizeFirst ?? "";
//       setState(() {
//         if (user.preferences != null &&
//             user.preferences!.ageRange != null &&
//             user.preferences!.ageRange!.length >= 2) {
//           ageRange = RangeValues(
//             user.preferences!.ageRange![0].toDouble(),
//             user.preferences!.ageRange![1].toDouble(),
//           );
//         }
//         distance = user.preferences?.maxDistance?.toDouble() ?? 0.0;
//       });
//     });
//   }

//   Future<void> savePreferences() async {
//     await _userController.updatePreference(
//       minAge: ageRange.start.toInt().toString(),
//       maxAge: ageRange.end.toInt().toString(),
//       interestedIn: interestedIn.value,
//       distance: (distance).toInt().toString(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Preferences",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16.0,
//           vertical: 30,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Show Me",
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Obx(
//               () => RadioListTile(
//                 activeColor: AppColors.primaryColor,
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 visualDensity: VisualDensity.compact,
//                 contentPadding: EdgeInsets.zero,
//                 title: const Text("Male"),
//                 value: "Male",
//                 groupValue: interestedIn.value,
//                 onChanged: (value) {
//                   interestedIn.value = value as String;
//                 },
//               ),
//             ),
//             Obx(
//               () => RadioListTile(
//                 activeColor: AppColors.primaryColor,
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 visualDensity: VisualDensity.compact,
//                 contentPadding: EdgeInsets.zero,
//                 title: const Text("Female"),
//                 value: "Female",
//                 groupValue: interestedIn.value,
//                 onChanged: (value) {
//                   interestedIn.value = value as String;
//                 },
//               ),
//             ),
//             Obx(
//               () => RadioListTile(
//                 activeColor: AppColors.primaryColor,
//                 materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 visualDensity: VisualDensity.compact,
//                 contentPadding: EdgeInsets.zero,
//                 title: const Text("Both"),
//                 value: "Both",
//                 groupValue: interestedIn.value,
//                 onChanged: (value) {
//                   interestedIn.value = value as String;
//                 },
//               ),
//             ),
//             const Divider(),

//             // Maximum Distance
//             Text(
//               "Maximum Distance (${distance.toInt()} km)",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             Slider(
//               activeColor: AppColors.primaryColor,
//               value: distance.clamp(1.0, 1000.0),
//               min: 1,
//               max: 1000,
//               divisions: 50,
//               onChanged: (value) {
//                 setState(() {
//                   distance = value;
//                 });
//               },
//             ),
//             const Divider(),

//             // Age Range Preference
//             Text(
//               "Age Range (${ageRange.start.toInt()} - ${ageRange.end.toInt()})",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             RangeSlider(
//               activeColor: AppColors.primaryColor,
//               values: ageRange,
//               min: 18,
//               max: 100,
//               divisions: 5,
//               labels: RangeLabels(
//                 ageRange.start.toInt().toString(),
//                 ageRange.end.toInt().toString(),
//               ),
//               onChanged: (values) {
//                 setState(() {
//                   ageRange = values;
//                 });
//               },
//             ),
//             const Spacer(),
//             Obx(
//               () => CustomButton(
//                 ontap: _userController.isloading.value
//                     ? () {}
//                     : () => savePreferences(),
//                 child: _userController.isloading.value
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor:
//                               AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : const Text(
//                         "Save",
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
