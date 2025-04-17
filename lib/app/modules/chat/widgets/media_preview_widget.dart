

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
              return AudioFileWaveforms(
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
              );
            } else {
              return const SizedBox();
            }
          }),
          
          const SizedBox(height: 10),
          
          // Audio controls
          Obx(() {
            if (controller.selectedFile.value != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: controller.togglePlayback,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                    onPressed: () {
                      controller.selectedFile.value = null;
                      controller.showAudioPreview.value = false;
                    },
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
    );
  }
}

class MediaPreviewWidget extends StatelessWidget {
  final ChatMediaController controller;

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
                      if (file == null) return const SizedBox.shrink();
                      
                      if (controller.isVideoFile(file.path)) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            if (controller.thumbnailData.value != null)
                              Image.memory(
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
                          file,
                          fit: BoxFit.cover,
                          width: Get.width * 0.2,
                        );
                      }
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
            },
          ),
        ],
      ),
    );
  }
}