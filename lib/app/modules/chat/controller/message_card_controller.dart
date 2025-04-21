// import 'dart:io';

// import 'package:audio_waveforms/audio_waveforms.dart';
// import 'package:echodate/app/models/message_model.dart';
// import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
// import 'package:echodate/app/widget/snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:path_provider/path_provider.dart';
// import 'package:video_player/video_player.dart';

// class MessageCardController extends GetxController {
//   VideoPlayerController? videoController;
//   PlayerController? audioController;
//   RxBool isPlaying = false.obs;
//   RxBool isLoading = false.obs;
//   RxString localPath = ''.obs;

//   RxBool isCancelled = false.obs;
//   RxString oldMediaUrl = "".obs;
//   RxBool hasInitialized = false.obs;

//   void init(String? url) {
//     oldMediaUrl.value = url ?? "";
//   }

//   Future<void> ensureControllerInitialized({
//     required MessageModel messageModel,
//     required bool mounted,
//   }) async {
//     if (hasInitialized.value) return;

//     if (getMessageType(messageModel.messageType) == MessageType.video &&
//         messageModel.mediaUrl != null) {
//       initializeVideoController(
//         messageModel,
//         mounted,
//       );
//       hasInitialized.value = true;
//     } else if (getMessageType(messageModel.messageType) == MessageType.audio &&
//         messageModel.mediaUrl != null) {
//       await initializeAudioController(
//         mounted,
//         messageModel,
//       );
//       hasInitialized.value = true;
//     }
//   }

//   Future<String> downloadAudio(
//     String url,
//     bool mounted,
//   ) async {
//     try {
//       if (isCancelled.value) return "";
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode != 200) {
//         return "";
//       }
//       if (isCancelled.value) return "";

//       Uri uri = Uri.parse(url);
//       String filename = uri.pathSegments.last;
//       Directory tempDir = await getTemporaryDirectory();
//       String savePath = '${tempDir.path}/$filename';
//       File saveFile = File(savePath);
//       await saveFile.writeAsBytes(response.bodyBytes);
//       return savePath;
//     } catch (e) {
//       if (mounted) {
//         CustomSnackbar.showErrorSnackBar("Failed to download audio");
//       }
//       return "";
//     }
//   }

//   Future<void> initializeAudioController(
//     bool mounted,
//     MessageModel messageModel,
//   ) async {
//     if (!mounted) return;
//     if (isLoading.value && messageModel.mediaUrl == oldMediaUrl.value) return;
//     isLoading.value = true;

//     final mediaUrl = messageModel.mediaUrl;
//     if (mediaUrl == null || mediaUrl.isEmpty) {
//       isLoading.value = false;
//       return;
//     }

//     await disposeAudioController();

//     try {
//       localPath.value = await downloadAudio(mediaUrl, mounted);
//       if (!mounted || isCancelled.value || localPath.isEmpty) {
//         isLoading.value = false;
//         return;
//       }

//       audioController = PlayerController();

//       await audioController!.preparePlayer(
//         path: localPath.value,
//         shouldExtractWaveform: true,
//         noOfSamples: 100,
//       );

//       if (!mounted || isCancelled.value) {
//         await disposeAudioController();
//         isLoading.value = false;
//         return;
//       }

//       audioController!.onPlayerStateChanged.listen((state) {
//         if (!mounted || isCancelled.value) return;
//         isPlaying.value = state == PlayerState.playing;
//       });
//     } catch (e) {
//       if (mounted) {
//         CustomSnackbar.showErrorSnackBar("Error initializing audio");
//       }
//       await disposeAudioController();
//     } finally {
//       if (mounted) {
//         isLoading.value = false;
//       }
//     }
//   }

//   Future<void> disposeAudioController() async {
//     if (audioController == null) return;
//     try {
//       await audioController!.pausePlayer();
//     } catch (_) {}
//     try {
//       audioController!.dispose();
//     } catch (_) {}
//     audioController = null;
//   }

//   void initializeVideoController(
//     MessageModel messageModel,
//     bool mounted,
//   ) {
//     if (videoController != null) {
//       videoController!.dispose();
//     }

//     if (messageModel.mediaUrl == null || messageModel.mediaUrl!.isEmpty) {
//       return;
//     }

//     videoController = VideoPlayerController.networkUrl(
//       Uri.parse(messageModel.mediaUrl ?? ""),
//     );

//     // videoController!.addListener(() {
//     //   if (mounted && !isCancelled.value) {}
//     // });

//     videoController!.initialize().then((_) {
//       if (mounted && !isCancelled.value) {
//         videoController!.setVolume(1.0);
//       }
//     }).catchError((error) {
//       debugPrint("Video initialization error: $error");
//     });
//   }

//   void playPause(
//     bool mounted,
//     MessageModel messageModel,
//   ) async {
//     try {
//       final state = audioController?.playerState;

//       if (state == PlayerState.playing) {
//         await audioController?.pausePlayer();
//         return;
//       }

//       if (state == PlayerState.paused) {
//         await audioController?.startPlayer();
//         return;
//       }

//       // if (state == PlayerState.stopped) {
//       //   audioController = null;
//       //   if (localPath.isNotEmpty) {
//       //     audioController = PlayerController();
//       //     await audioController!.preparePlayer(
//       //       path: localPath.value,
//       //       shouldExtractWaveform: true,
//       //       noOfSamples: 100,
//       //     );
//       //     if (!mounted || isCancelled.value) return;

//       //     audioController!.onPlayerStateChanged.listen((state) {
//       //       if (!mounted || isCancelled.value) return;
//       //       isPlaying.value = state == PlayerState.playing;
//       //     });

//       //     if (!mounted || isCancelled.value) return;
//       //     await audioController?.startPlayer();
//       //   } else {
//       //     await initializeAudioController(mounted, messageModel);
//       //     if (mounted && !isCancelled.value) {
//       //       await audioController?.startPlayer();
//       //     }
//       //   }
//       //   return;
//       // }

//       if (state == PlayerState.initialized) {
//         await audioController?.startPlayer();
//         return;
//       }

//       if (audioController == null) {
//         await initializeAudioController(
//           mounted,
//           messageModel,
//         );
//         if (mounted && !isCancelled.value) {
//           await audioController?.startPlayer();
//         }
//       }

//       if (state != PlayerState.stopped) return;
//       audioController = null;

//       if (localPath.isEmpty) {
//         await initializeAudioController(mounted, messageModel);
//         if (!mounted || isCancelled.value) return;
//         await audioController?.startPlayer();
//         return;
//       }

//       audioController = PlayerController();

//       await audioController!.preparePlayer(
//         path: localPath.value,
//         shouldExtractWaveform: true,
//         noOfSamples: 100,
//       );

//       if (!mounted || isCancelled.value) return;

//       audioController!.onPlayerStateChanged.listen((state) {
//         if (!mounted || isCancelled.value) return;
//         isPlaying.value = state == PlayerState.playing;
//       });

//       if (!mounted || isCancelled.value) return;

//       await audioController?.startPlayer();
//     } catch (e) {
//       if (mounted) {
//         CustomSnackbar.showErrorSnackBar("Error Playing audio");
//       }
//     }
//   }

//   void cleanUp() {
//     isCancelled.value = true;
//     if (audioController != null) {
//       try {
//         audioController!.pausePlayer();
//       } catch (_) {}

//       try {
//         audioController!.dispose();
//       } catch (_) {}
//       audioController = null;
//     }

//     if (videoController != null) {
//       videoController!.dispose();
//       videoController = null;
//     }
//   }
// }
