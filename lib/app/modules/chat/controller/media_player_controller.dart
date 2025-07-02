
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MediaPlayerController extends GetxController {
  VideoPlayerController? _videoController;
  PlayerController? _audioController;
  
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final RxString localPath = ''.obs;
  final RxBool hasInitialized = false.obs;
  
  bool _isCancelled = false;
  String? _oldMediaUrl;

  // Video Controller Management
  Future<void> initializeVideoController(String mediaUrl) async {
    if (_videoController != null) {
      _videoController!.dispose();
    }

    if (mediaUrl.isEmpty) return;

    _videoController = VideoPlayerController.networkUrl(Uri.parse(mediaUrl));
    
    _videoController!.addListener(() {
      if (!_isCancelled) update();
    });

    try {
      await _videoController!.initialize();
      if (!_isCancelled) {
        _videoController!.setVolume(1.0);
        hasInitialized.value = true;
      }
    } catch (error) {
      debugPrint("Video initialization error: $error");
    }
  }

  // Audio Controller Management
  Future<void> initializeAudioController(String mediaUrl) async {
    if (isLoading.value && mediaUrl == _oldMediaUrl) return;
    
    isLoading.value = true;
    await _disposeAudioController();

    try {
      final downloadedPath = await _downloadAudio(mediaUrl);
      if (_isCancelled || downloadedPath.isEmpty) {
        isLoading.value = false;
        return;
      }

      localPath.value = downloadedPath;
      _audioController = PlayerController();

      await _audioController!.preparePlayer(
        path: downloadedPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
      );

      if (_isCancelled) {
        await _disposeAudioController();
        isLoading.value = false;
        return;
      }

      _audioController!.onPlayerStateChanged.listen((state) {
        if (!_isCancelled) {
          isPlaying.value = state == PlayerState.playing;
        }
      });

      hasInitialized.value = true;
    } catch (e) {
      CustomSnackbar.showErrorSnackBar("Error initializing audio");
      await _disposeAudioController();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _downloadAudio(String url) async {
    try {
      if (_isCancelled) return "";
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200 || _isCancelled) return "";

      final uri = Uri.parse(url);
      final filename = uri.pathSegments.last;
      final tempDir = await getTemporaryDirectory();
      final savePath = '${tempDir.path}/$filename';
      final saveFile = File(savePath);
      
      await saveFile.writeAsBytes(response.bodyBytes);
      return savePath;
    } catch (e) {
      CustomSnackbar.showErrorSnackBar("Failed to download audio");
      return "";
    }
  }

  Future<void> playPauseAudio() async {
    try {
      final state = _audioController?.playerState;

      switch (state) {
        case PlayerState.playing:
          await _audioController?.pausePlayer();
          break;
        case PlayerState.paused:
        case PlayerState.initialized:
          await _audioController?.startPlayer();
          break;
        case PlayerState.stopped:
          await _reinitializeAudioController();
          break;
        default:
          if (_audioController == null) {
            // Handle reinitialization if needed
          }
      }
    } catch (e) {
      CustomSnackbar.showErrorSnackBar("Error Playing audio");
    }
  }

  Future<void> _reinitializeAudioController() async {
    _audioController = null;
    if (localPath.value.isNotEmpty) {
      _audioController = PlayerController();
      await _audioController!.preparePlayer(
        path: localPath.value,
        shouldExtractWaveform: true,
        noOfSamples: 100,
      );

      if (!_isCancelled) {
        _audioController!.onPlayerStateChanged.listen((state) {
          if (!_isCancelled) {
            isPlaying.value = state == PlayerState.playing;
          }
        });
        await _audioController?.startPlayer();
      }
    }
  }

  Future<void> _disposeAudioController() async {
    if (_audioController == null) return;
    
    try {
      await _audioController!.pausePlayer();
      _audioController!.dispose();
    } catch (_) {}
    _audioController = null;
  }

  void reset() {
    _isCancelled = false;
    hasInitialized.value = false;
    isPlaying.value = false;
    isLoading.value = false;
    localPath.value = '';
  }

  VideoPlayerController? get videoController => _videoController;
  PlayerController? get audioController => _audioController;

  @override
  void onClose() {
    _isCancelled = true;
    
    if (_audioController != null) {
      try {
        _audioController!.pausePlayer();
        _audioController!.dispose();
      } catch (_) {}
    }

    _videoController?.dispose();
    super.onClose();
  }
}