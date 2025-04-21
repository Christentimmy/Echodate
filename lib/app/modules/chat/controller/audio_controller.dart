import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:echodate/app/widget/snack_bar.dart';

class AudioController extends GetxController {
  final RecorderController recorderController = RecorderController();
  final PlayerController playerController = PlayerController();

  final Rxn<File> selectedFile = Rxn<File>(null);
  final RxBool isRecording = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool showAudioPreview = false.obs;

  String? _audioFilePath;

  @override
  void onInit() {
    super.onInit();
    playerController.onCompletion.listen((_) async {
      isPlaying.value = false;
      if (selectedFile.value != null && isAudioFile(selectedFile.value!.path)) {
        await playerController.stopPlayer();
        await playerController.preparePlayer(
          path: selectedFile.value!.path,
        );
      }
    });
  }

  bool isAudioFile(String path) {
    return path.toLowerCase().endsWith('.aac') ||
        path.toLowerCase().endsWith('.mp3') ||
        path.toLowerCase().endsWith('.wav');
  }

  String? getFileType(String path) {
    if (isAudioFile(path)) {
      return "audio";
    }
    return null;
  }

  Future<void> startRecording() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        CustomSnackbar.showErrorSnackBar("Permission denied");
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      _audioFilePath =
          '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.aac';

      await recorderController.record(
        path: _audioFilePath,
        bitRate: 128000,
      );

      isRecording.value = true;
      showAudioPreview.value = true;
    } catch (e) {
      debugPrint("Error starting recording: $e");
      CustomSnackbar.showErrorSnackBar("Failed to start recording");
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await recorderController.stop();
      isRecording.value = false;

      if (path != null) {
        selectedFile.value = File(path);
        showAudioPreview.value = true;
        await playerController.preparePlayer(
          path: path,
          noOfSamples: 100,
          shouldExtractWaveform: true,
        );
      }
    } catch (e) {
      debugPrint("Error stopping recording: $e");
      CustomSnackbar.showErrorSnackBar("Failed to process recording");
      isRecording.value = false;
    }
  }

  Future<void> togglePlayback() async {
    try {
      if (selectedFile.value == null ||
          !isAudioFile(selectedFile.value!.path)) {
        CustomSnackbar.showErrorSnackBar("Invalid audio file");
        return;
      }

      final currentState = playerController.playerState;

      if (currentState == PlayerState.playing) {
        await playerController.pausePlayer();
        isPlaying.value = false;
        return;
      }

      // Always prepare the player before starting playback
      await playerController.preparePlayer(
        path: selectedFile.value!.path,
        noOfSamples: 44100,
        shouldExtractWaveform: true,
      );

      // Set up completion listener
      playerController.onCompletion.listen((_) {
        isPlaying.value = false;
        playerController.pausePlayer();
      });

      await playerController.startPlayer();
      isPlaying.value = true;
    } catch (e) {
      debugPrint("Error toggling playback: $e");
      CustomSnackbar.showErrorSnackBar("Error playing audio");
      isPlaying.value = false;
    }
  }

  // Reset all state
  void resetState() {
    selectedFile.value = null;
    showAudioPreview.value = false;
    if (isPlaying.value) {
      playerController.pausePlayer();
      isPlaying.value = false;
    }
  }

  @override
  void onClose() {
    resetState();
    recorderController.dispose();
    playerController.dispose();
    super.onClose();
  }
}
