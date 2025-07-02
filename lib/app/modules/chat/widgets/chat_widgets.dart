import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
import 'package:echodate/app/modules/chat/views/view_medial_full_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class AnimatedImagePreview extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;
  const AnimatedImagePreview({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });
  @override
  State<AnimatedImagePreview> createState() => AnimatedImagePreviewState();
}

class AnimatedImagePreviewState extends State<AnimatedImagePreview> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          highlightColor: AppColors.primaryColor,
          baseColor: Colors.grey.shade100.withOpacity(0.1),
          child: Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey.shade300,
          ),
        );
      },
    );
    // return AnimatedScale(
    //   scale: _loaded ? 1.0 : 0.9,
    //   duration: const Duration(milliseconds: 350),
    //   curve: Curves.easeOutCubic,
    //   child: AnimatedOpacity(
    //     opacity: _loaded ? 1.0 : 0.0,
    //     duration: const Duration(milliseconds: 350),
    //     curve: Curves.easeOutCubic,
    //     child: CachedNetworkImage(
    //       imageUrl: widget.imageUrl,
    //       width: widget.width,
    //       height: widget.height,
    //       fit: BoxFit.cover,
    //       placeholder: (context, url) {
    //         return Shimmer.fromColors(
    //           highlightColor: Colors.red,
    //           baseColor: Colors.blue,
    //           child: Container(
    //             width: widget.width,
    //             height: widget.height,
    //             color: Colors.grey.shade300,
    //           ),
    //         );
    //       },
    //       imageBuilder: (context, imageProvider) {
    //         if (!_loaded) {
    //           WidgetsBinding.instance.addPostFrameCallback((_) {
    //             if (mounted) setState(() => _loaded = true);
    //           });
    //         }
    //         return Image(
    //           image: imageProvider,
    //           width: widget.width,
    //           height: widget.height,
    //           fit: BoxFit.cover,
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}

class AnimatedVideoPreview extends StatefulWidget {
  final Widget child;
  const AnimatedVideoPreview({super.key, required this.child});
  @override
  State<AnimatedVideoPreview> createState() => AnimatedVideoPreviewState();
}

class AnimatedVideoPreviewState extends State<AnimatedVideoPreview> {
  bool _shown = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _shown ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _shown ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
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

class _ReceiverCardState extends State<ReceiverCard>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _videoController;
  PlayerController? _audioController;
  bool isPlaying = false;
  bool isLoading = false;
  String localPath = '';
  bool _isCancelled = false;
  String? _oldMediaUrl;
  bool _hasInitialized = false;
  double _scale = 1.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _oldMediaUrl = widget.messageModel.mediaUrl;
  }

  Future<void> _ensureControllerInitialized() async {
    if (_hasInitialized) return;

    if (getMessageType(widget.messageModel.messageType) == MessageType.video &&
        widget.messageModel.mediaUrl != null) {
      _initializeVideoController();
      _hasInitialized = true;
    } else if (getMessageType(widget.messageModel.messageType) ==
            MessageType.audio &&
        widget.messageModel.mediaUrl != null) {
      await _initializeAudioController();
      _hasInitialized = true;
    }
  }

  Future<String> _downloadAudio(String url) async {
    try {
      if (_isCancelled) return "";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return "";
      }
      if (_isCancelled) return "";

      Uri uri = Uri.parse(url);
      String filename = uri.pathSegments.last;
      Directory tempDir = await getTemporaryDirectory();
      String savePath = '${tempDir.path}/$filename';
      File saveFile = File(savePath);
      await saveFile.writeAsBytes(response.bodyBytes);
      return savePath;
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showErrorSnackBar("Failed to download audio");
      }
      return "";
    }
  }

  void _initializeVideoController() {
    if (_videoController != null) {
      _videoController!.dispose();
    }

    if (widget.messageModel.mediaUrl == null ||
        widget.messageModel.mediaUrl!.isEmpty) {
      return;
    }

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.messageModel.mediaUrl ?? ""),
    );

    _videoController!.addListener(() {
      if (mounted && !_isCancelled) {
        setState(() {});
      }
    });

    _videoController!.initialize().then((_) {
      if (mounted && !_isCancelled) {
        setState(() {});
        _videoController!.setVolume(1.0);
      }
    }).catchError((error) {
      debugPrint("Video initialization error: $error");
    });
  }

  Future<void> _initializeAudioController() async {
    try {
      if (!mounted) return;
      if (isLoading && widget.messageModel.mediaUrl == _oldMediaUrl) {
        return;
      }

      setState(() => isLoading = true);
      if (widget.messageModel.mediaUrl == null ||
          widget.messageModel.mediaUrl!.isEmpty) {
        setState(() => isLoading = false);
        return;
      }
      if (_audioController != null) {
        try {
          await _audioController!.pausePlayer();
        } catch (_) {}

        try {
          _audioController!.dispose();
        } catch (_) {}
        _audioController = null;
      }
      localPath = await _downloadAudio(widget.messageModel.mediaUrl!);
      if (!mounted || _isCancelled || localPath.isEmpty) {
        setState(() => isLoading = false);
        return;
      }
      _audioController = PlayerController();
      try {
        await _audioController!.preparePlayer(
          path: localPath,
          shouldExtractWaveform: true,
          noOfSamples: 100,
        );
      } catch (e) {
        if (mounted) {
          CustomSnackbar.showErrorSnackBar("Error preparing audio player");
        }
        _audioController = null;
        setState(() => isLoading = false);
        return;
      }

      if (!mounted || _isCancelled) {
        _audioController?.dispose();
        _audioController = null;
        return;
      }

      setState(() => isLoading = false);
      _audioController!.onPlayerStateChanged.listen((state) {
        if (!mounted || _isCancelled) return;
        if (state == PlayerState.stopped) {
          setState(() {
            isPlaying = false;
          });
        } else {
          setState(() => isPlaying = state == PlayerState.playing);
        }
      });
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showErrorSnackBar("Error Playing Audio");
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void playPause() async {
    try {
      final state = _audioController?.playerState;

      if (state == PlayerState.playing) {
        await _audioController?.pausePlayer();
        return;
      }

      if (state == PlayerState.paused) {
        await _audioController?.startPlayer();
        return;
      }

      if (state == PlayerState.stopped) {
        _audioController = null;

        if (localPath.isNotEmpty) {
          _audioController = PlayerController();
          await _audioController!.preparePlayer(
            path: localPath,
            shouldExtractWaveform: true,
            noOfSamples: 100,
          );
          if (!mounted || _isCancelled) return;

          _audioController!.onPlayerStateChanged.listen((state) {
            if (!mounted || _isCancelled) return;
            setState(() => isPlaying = state == PlayerState.playing);
          });

          if (!mounted || _isCancelled) return;
          await _audioController?.startPlayer();
        } else {
          await _initializeAudioController();
          if (mounted && !_isCancelled) {
            await _audioController?.startPlayer();
          }
        }
        return;
      }

      if (state == PlayerState.initialized) {
        await _audioController?.startPlayer();
        return;
      }

      if (_audioController == null) {
        await _initializeAudioController();
        if (mounted && !_isCancelled) {
          await _audioController?.startPlayer();
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showErrorSnackBar("Error Playing audio");
      }
    }
  }

  void _onLongPress() async {
    setState(() => _scale = 0.96);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _isCancelled = true;
    if (_audioController != null) {
      try {
        _audioController!.pausePlayer();
      } catch (_) {}

      try {
        _audioController!.dispose();
      } catch (_) {}
      _audioController = null;
    }

    if (_videoController != null) {
      _videoController!.dispose();
      _videoController = null;
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(ReceiverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messageModel.mediaUrl != widget.messageModel.mediaUrl) {
      _oldMediaUrl = widget.messageModel.mediaUrl;
      _hasInitialized = false;

      if (_videoController != null) {
        _videoController!.dispose();
        _videoController = null;
      }

      if (_audioController != null) {
        try {
          _audioController!.pausePlayer();
          _audioController!.dispose();
        } catch (_) {}
        _audioController = null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isTyping = widget.messageModel.status == "typing";
    return AnimatedOpacity(
      opacity: isTyping ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      child: isTyping
          ? Padding(
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
            )
          : Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onLongPress: _onLongPress,
                child: AnimatedScale(
                  scale: _scale,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
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
                              ? DateFormat("hh:mm a")
                                  .format(widget.messageModel.createdAt!)
                              : "",
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildAudioContent() {
    if (widget.messageModel.status == "sending") {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.black54,
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (widget.messageModel.mediaUrl == null ||
        widget.messageModel.mediaUrl?.isEmpty == true) {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            "Audio unavailable",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () async {
              if (_audioController == null && !isLoading) {
                await _ensureControllerInitialized();
              }
              if (_audioController != null && !isLoading) {
                playPause();
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
                ? Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    child: Container(
                      height: 2,
                      color: Colors.black38,
                    ),
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
    if (getMessageType(widget.messageModel.messageType) == MessageType.image &&
        widget.messageModel.mediaUrl?.isNotEmpty == true) {
      return InkWell(
        onTap: () {
          Get.to(() => ViewMedialFullScreen(
                message: widget.messageModel,
              ));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: AnimatedImagePreview(
            imageUrl: widget.messageModel.mediaUrl ?? "",
            width: Get.width * 0.558,
            height: Get.height * 0.32,
          ),
        ),
      );
    }

    if (getMessageType(widget.messageModel.messageType) == MessageType.video) {
      return InkWell(
        onTap: () async {
          if (_videoController == null) {
            await _ensureControllerInitialized();
          }

          Get.to(
            () => ViewMedialFullScreen(
              message: widget.messageModel,
            ),
          );
        },
        child: Container(
          width: Get.width * 0.558,
          height: Get.height * 0.32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.1),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_videoController != null &&
                  _videoController!.value.isInitialized)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedVideoPreview(
                    child: SizedBox(
                      width: Get.width * 0.558,
                      height: Get.height * 0.32,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
              if (_videoController == null ||
                  !_videoController!.value.isInitialized)
                const AnimatedVideoPreview(
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.black54,
                    size: 50,
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
