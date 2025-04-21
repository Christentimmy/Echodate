// import 'package:echodate/app/modules/auth/views/create_new_password.dart';
// import 'package:echodate/app/modules/auth/views/otp_verify_screen.dart';
// import 'package:echodate/app/modules/auth/views/signup_screen.dart';
// import 'package:echodate/app/modules/auth/views/verification_status_screen.dart';
// import 'package:echodate/app/modules/bottom_navigation/views/bottom_navigation_screen.dart';
// import 'package:echodate/app/modules/chat/views/chat_screen.dart';
// import 'package:echodate/app/modules/gender/views/gender_screen.dart';
// import 'package:echodate/app/modules/profile/views/complete_profile_screen.dart';
// import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
// import 'package:echodate/app/routes/app_routes.dart';
// import 'package:get/get.dart';
// import 'package:echodate/app/models/chat_list_model.dart';

// class AppPages {
//   static const INITIAL = Routes.SIGNUP;

//   static final routes = [
//     GetPage(
//       name: Routes.SIGNUP,
//       page: () => RegisterScreen(),
//     ),
//     GetPage(
//       name: Routes.OTP_VERIFY,
//       page: () => OTPVerificationScreen(
//         email: null,
//         onVerifiedCallBack: () {},
//       ),
//     ),
//     GetPage(
//       name: Routes.VERIFICATION_STATUS,
//       page: () => VerificationStatusScreen(
//         callback: () {},
//       ),
//     ),
//     GetPage(
//       name: Routes.CREATE_NEW_PASSWORD,
//       page: () => CreateNewPasswordScreen(
//         email: '',
//       ),
//     ),
//     GetPage(
//       name: Routes.BOTTOM_NAVIGATION,
//       page: () => BottomNavigationScreen(),
//     ),
//     GetPage(
//       name: Routes.CHAT,
//       page: () => ChatScreen(
//         chatHead: ChatListModel(
//           userId: '',
//           fullName: '',
//           avatar: '',
//           lastMessage: '',
//           unreadCount: 0,
//           online: false,
//         ),
//       ),
//     ),
//     GetPage(
//       name: Routes.GENDER_SELECTION,
//       page: () => GenderSelectionScreen(),
//     ),
//     GetPage(
//       name: Routes.COMPLETE_PROFILE,
//       page: () => CompleteProfileScreen(),
//     ),
//     GetPage(
//       name: Routes.SUBSCRIPTION,
//       page: () => SubscriptionScreen(),
//     ),
//   ];
// }
