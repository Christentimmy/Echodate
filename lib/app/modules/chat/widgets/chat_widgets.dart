import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/views/view_medial_full_screen.dart';
import 'package:echodate/app/utils/shimmer_effect.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class SenderCard extends StatefulWidget {
  final MessageModel messageModel;

  const SenderCard({super.key, required this.messageModel});

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard> {
  VideoPlayerController? _videoController;
  PlayerController? _audioController;
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.messageModel.messageType == 'video' &&
        widget.messageModel.mediaUrl != null) {
      _initializeVideoController();
    } else if (widget.messageModel.messageType == 'audio' &&
        widget.messageModel.mediaUrl != null) {
      _initializeAudioController();
    }
  }

  void _initializeVideoController() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.messageModel.mediaUrl ?? ""))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.setVolume(1.0);
      }).catchError((error) {
        print("Video initialization error: $error");
      });
  }

  Future<String> _downloadAudio(String url) async {
    final response = await http.get(Uri.parse(url));
    Directory tempDir = await getTemporaryDirectory();
    String savePath = '${tempDir.path}/audiofile.mp3';
    File saveFile = File(savePath);
    await saveFile.writeAsBytes(response.bodyBytes);
    return savePath;
  }

  void _initializeAudioController() async {
    setState(() => isLoading = true);
    try {
      String localPath = await _downloadAudio(widget.messageModel.mediaUrl!);

      _audioController = PlayerController();
      await _audioController!.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
        noOfSamples: 100,
      );

      _audioController!.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.stopped) {
          setState(() {
            isPlaying = false; // Reset the play button after audio finishes
          });
        } else {
          setState(() => isPlaying = state == PlayerState.playing);
        }
      });
    } catch (e) {
      print("Audio initialization error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void didUpdateWidget(SenderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the message status changed from 'sending' to something else,
    // and it's a video, initialize the video controller
    if (oldWidget.messageModel.status == 'sending' &&
        widget.messageModel.status != 'sending' &&
        widget.messageModel.messageType == 'video' &&
        widget.messageModel.mediaUrl != null) {
      _initializeVideoController();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.messageModel.messageType == "image" ||
                widget.messageModel.messageType == "video")
              _buildMediaContent(),
            if (widget.messageModel.messageType == "audio")
              _buildAudioContent(),
            if (widget.messageModel.message?.isNotEmpty == true)
              Text(
                widget.messageModel.message ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 3),
            Text(
              widget.messageModel.createdAt != null
                  ? DateFormat("hh:mm a").format(widget.messageModel.createdAt!)
                  : "",
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioContent() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button with loading state
          InkWell(
            onTap: _audioController == null || isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    try {
                      if (isPlaying) {
                        await _audioController?.pausePlayer();
                      } else {
                        await _audioController?.startPlayer();
                      }
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
            child: SizedBox(
              width: 30,
              height: 30,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _audioController == null
                ? const SizedBox(
                    height: 40,
                    width: 100,
                    child: Center(child: Loader()),
                  )
                : AudioFileWaveforms(
                    playerController: _audioController!,
                    size: Size(Get.width * 0.4, 40),
                    playerWaveStyle: const PlayerWaveStyle(
                      fixedWaveColor: Colors.white54,
                      liveWaveColor: Colors.white,
                      spacing: 6,
                      waveThickness: 2,
                    ),
                    enableSeekGesture: true,
                    continuousWaveform: true,
                    waveformType: WaveformType.long,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent() {
    if (widget.messageModel.status == "sending" &&
        widget.messageModel.messageType == "image") {
      return Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.file(
                widget.messageModel.tempFile!,
                width: Get.width * 0.558,
                height: Get.height * 0.32,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Center(
            child: SizedBox(
              width: 45,
              child: Loader(),
            ),
          ),
        ],
      );
    }
    if (widget.messageModel.messageType == "image") {
      return InkWell(
        onTap: () {
          Get.to(
            () => ViewMedialFullScreen(message: widget.messageModel),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
              imageUrl: widget.messageModel.mediaUrl ?? "",
              width: Get.width * 0.558,
              height: Get.height * 0.32,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return ShimmerWrapper(
                  child: SizedBox(
                    width: Get.width * 0.558,
                    height: Get.height * 0.32,
                  ),
                );
              }),
        ),
      );
    } else if (widget.messageModel.messageType == "video") {
      return _videoController != null && _videoController!.value.isInitialized
          ? InkWell(
              onTap: () {
                Get.to(() => ViewMedialFullScreen(
                      message: widget.messageModel,
                    ));
              },
              child: SizedBox(
                width: Get.width * 0.558,
                height: Get.height * 0.32,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: Get.width * 0.558,
                    height: Get.height * 0.32,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
    }
    return const SizedBox.shrink();
  }
}

class ReceiverCard extends StatefulWidget {
  final MessageModel messageModel;

  const ReceiverCard({
    super.key,
    required this.messageModel,
  });

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard> {
  VideoPlayerController? _videoController;
  PlayerController? _audioController;
  bool isPlaying = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.messageModel.messageType == 'audio' &&
        widget.messageModel.mediaUrl != null) {
      _initializeAudioController();
    } else if (widget.messageModel.messageType == 'video' &&
        widget.messageModel.mediaUrl != null) {
      _initializeVideoController();
    }
  }

  Future<String> _downloadAudio(String url) async {
    final response = await http.get(Uri.parse(url));
    Directory tempDir = await getTemporaryDirectory();
    String savePath = '${tempDir.path}/audiofile.mp3';
    File saveFile = File(savePath);
    await saveFile.writeAsBytes(response.bodyBytes);
    return savePath;
  }

  void _initializeAudioController() async {
    setState(() => isLoading = true);
    try {
      String localPath = await _downloadAudio(widget.messageModel.mediaUrl!);

      _audioController = PlayerController();
      await _audioController!.preparePlayer(
        path: localPath,
        shouldExtractWaveform: true,
        noOfSamples: 100, // Reduced from 44100 for better performance
      );

      _audioController!.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.stopped) {
          setState(() {
            isPlaying = false; // Reset the play button after audio finishes
          });
        } else {
          setState(() => isPlaying = state == PlayerState.playing);
        }
      });
    } catch (e) {
      print("Audio initialization error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _initializeVideoController() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.messageModel.mediaUrl ?? ""))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.setVolume(1.0);
      }).catchError((error) {
        print("Video initialization error: $error");
      });
  }

  @override
  void dispose() {
    _audioController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messageModel.status == "typing") {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 5,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Lottie.asset(
            "assets/images/typing.json",
            height: 50,
          ),
        ),
      );
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: Get.width * 0.6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Build media content based on message type
            if (widget.messageModel.messageType == "audio")
              _buildAudioContent(),
            if (widget.messageModel.messageType == "image" ||
                widget.messageModel.messageType == "video")
              _buildMediaContent(),

            // Text message
            if (widget.messageModel.message?.isNotEmpty == true)
              Text(
                widget.messageModel.message ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 3),

            // Timestamp
            Text(
              widget.messageModel.createdAt != null
                  ? DateFormat("hh:mm a").format(widget.messageModel.createdAt!)
                  : "",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioContent() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button with loading state
          InkWell(
            onTap: _audioController == null || isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    try {
                      if (isPlaying) {
                        await _audioController?.pausePlayer();
                      } else {
                        await _audioController?.startPlayer();
                      }
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
            child: SizedBox(
              width: 30,
              height: 30,
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.black54,
                      strokeWidth: 2,
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.black54,
                      size: 30,
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _audioController == null
                ? const SizedBox(
                    height: 40,
                    width: 100,
                    child: Center(child: Loader()),
                  )
                : AudioFileWaveforms(
                    playerController: _audioController!,
                    size: Size(Get.width * 0.4, 40),
                    playerWaveStyle: const PlayerWaveStyle(
                      fixedWaveColor: Colors.black38,
                      liveWaveColor: Colors.black87,
                      spacing: 6,
                      waveThickness: 2,
                    ),
                    enableSeekGesture: true,
                    continuousWaveform: true,
                    waveformType: WaveformType.long,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent() {
    if (widget.messageModel.messageType == "image" &&
        widget.messageModel.mediaUrl?.isNotEmpty == true) {
      return InkWell(
        onTap: () {
          Get.to(() => ViewMedialFullScreen(
                message: widget.messageModel,
              ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: widget.messageModel.mediaUrl ?? "",
            width: Get.width * 0.558,
            height: Get.height * 0.32,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      );
    }

    if (widget.messageModel.messageType == "video") {
      return _videoController != null && _videoController!.value.isInitialized
          ? InkWell(
              onTap: () {
                Get.to(() => ViewMedialFullScreen(
                      message: widget.messageModel,
                    ));
              },
              child: SizedBox(
                width: Get.width * 0.558,
                height: Get.height * 0.32,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: Get.width * 0.558,
                    height: Get.height * 0.32,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
    }

    return const SizedBox.shrink();
  }
}
