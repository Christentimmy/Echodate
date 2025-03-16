import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewMedialFullScreen extends StatefulWidget {
  final MessageModel message;
  const ViewMedialFullScreen({
    super.key,
    required this.message,
  });

  @override
  State<ViewMedialFullScreen> createState() => _ViewMedialFullScreenState();
}

class _ViewMedialFullScreenState extends State<ViewMedialFullScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    _initializeMedia();
    super.initState();
  }

  void _initializeMedia() {
    if (widget.message.messageType == 'video') {
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(
          Uri.parse(widget.message.mediaUrl ?? ""))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.setVolume(1.0);
          _videoController!.play();
        }).catchError((error) {
          print("Video initialization error: $error");
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.message.messageType == 'video'
          ? (_videoController != null && _videoController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: Center(child: VideoPlayer(_videoController!)),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                ))
          : CachedNetworkImage(
              imageUrl: widget.message.mediaUrl ?? "",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fitWidth,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
            ),
    );
  }
}
