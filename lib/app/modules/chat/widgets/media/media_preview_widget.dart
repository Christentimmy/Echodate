import 'dart:io';

import 'package:echodate/app/modules/chat/controller/audio_controller.dart';
import 'package:echodate/app/modules/chat/controller/chat_media_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPreviewWidget extends StatelessWidget {
  final AudioController controller;

  const AudioPreviewWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          // Audio waveform display
          Obx(() {
            if (controller.isRecording.value) {
              return AudioWaveforms(
                enableGesture: true,
                size: Size(
                  MediaQuery.of(context).size.width * 0.8,
                  50,
                ),
                recorderController: controller.recorderController,
                waveStyle: const WaveStyle(
                  waveColor: Colors.orange,
                  extendWaveform: true,
                  showMiddleLine: false,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              );
            } else if (controller.selectedFile.value != null) {
              return Row(
                children: [
                  Expanded(
                    child: AudioFileWaveforms(
                      size: Size(
                        MediaQuery.of(context).size.width * 0.8,
                        50,
                      ),
                      playerController: controller.playerController,
                      enableSeekGesture: true,
                      continuousWaveform: true,
                      waveformType: WaveformType.fitWidth,
                      playerWaveStyle: const PlayerWaveStyle(
                        fixedWaveColor: Colors.blue,
                        liveWaveColor: Colors.orange,
                        spacing: 6.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (controller.selectedFile.value != null) {
                      return IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          controller.selectedFile.value = null;
                          controller.showAudioPreview.value = false;
                        },
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),

          // Audio controls
        ],
      ),
    );
  }
}

class MediaPreviewWidget extends StatelessWidget {
  final ChatMediaPickerHelper controller;

  const MediaPreviewWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 100,
                    child: Obx(() {
                      final file = controller.selectedFile.value;
                      final multipleMediaList =
                          controller.multipleMediaSelected;
                      return _buildContent(multipleMediaList, file);
                    }),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              controller.selectedFile.value = null;
              controller.showMediaPreview.value = false;
              controller.multipleMediaSelected.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List? multipleMediaList, File? imageOrThumbNail) {
    // final multipleMediaList = controller.multipleMediaSelected.value;
    if ((multipleMediaList == null || multipleMediaList.isEmpty) &&
        imageOrThumbNail == null) {
      return const SizedBox.shrink();
    }
    if (multipleMediaList!.isNotEmpty) {
      return ListView.builder(
        itemCount: multipleMediaList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 5,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    multipleMediaList[index],
                    width: 80,
                    height: 98,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    onTap: () {
                      controller.multipleMediaSelected.removeAt(index);
                    },
                    child: const Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    if (imageOrThumbNail != null &&
        controller.isVideoFile(imageOrThumbNail.path)) {
      return Stack(
        alignment: Alignment.center,
        children: [
          if (controller.thumbnailData.value != null)
            Image.file(
              controller.thumbnailData.value!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          Icon(
            Icons.play_circle_fill,
            size: 40,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      );
    } else {
      return Image.file(
        imageOrThumbNail!,
        fit: BoxFit.cover,
        width: Get.width * 0.2,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image);
        },
      );
    }
  }
}
