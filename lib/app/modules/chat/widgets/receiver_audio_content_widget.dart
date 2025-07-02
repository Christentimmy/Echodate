import 'package:echodate/app/modules/chat/controller/receiver_card_controller.dart';
import 'package:echodate/app/modules/chat/widgets/base_audio_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class ReceiverAudioContentWidget extends BaseAudioContentWidget {
  final ReceiverCardController controller;

  const ReceiverAudioContentWidget({
    super.key,
    required super.messageModel,
    required this.controller,
  }) : super(
          isReceiver: true,
        );

  @override
  Widget buildPlayPauseButton() {
    return InkWell(
      onTap: () async {
        if (controller.mediaController.audioController == null &&
            !controller.mediaController.isLoading.value) {
          await controller.ensureControllerInitialized(messageModel);
        }
        if (controller.mediaController.audioController != null &&
            !controller.mediaController.isLoading.value) {
          await controller.mediaController.playPauseAudio();
        }
      },
      child: SizedBox(
        width: 30,
        height: 30,
        child: Obx(() => controller.mediaController.isLoading.value
            ? CircularProgressIndicator(
                color: iconColor,
                strokeWidth: 2,
              )
            : Icon(
                controller.mediaController.isPlaying.value
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: iconColor,
                size: 30,
              )),
      ),
    );
  }

  @override
  Widget buildWaveform() {
    return Obx(() {
      final audioController = controller.mediaController.audioController;

      if (audioController == null) {
        return Container(
          height: 40,
          width: 100,
          alignment: Alignment.center,
          child: Container(
            height: 2,
            color: waveformFixedColor,
          ),
        );
      }

      return AudioFileWaveforms(
        playerController: audioController,
        size: Size(Get.width * 0.4, 40),
        playerWaveStyle: PlayerWaveStyle(
          fixedWaveColor: waveformFixedColor,
          liveWaveColor: waveformLiveColor,
          spacing: 6,
          waveThickness: 2,
        ),
        enableSeekGesture: true,
        continuousWaveform: true,
        waveformType: WaveformType.long, // Different from sender
      );
    });
  }
}
