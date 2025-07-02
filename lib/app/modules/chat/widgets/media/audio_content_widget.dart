import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/controller/sender_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioContentWidget extends StatelessWidget {
  final MessageModel messageModel;
  final SenderCardController controller;

  const AudioContentWidget({
    super.key,
    required this.messageModel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (messageModel.status == "sending") {
      return _buildLoadingState();
    }

    if (messageModel.mediaUrl == null || messageModel.mediaUrl!.isEmpty) {
      return _buildUnavailableState();
    }

    return _buildAudioPlayer();
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _containerDecoration(),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildUnavailableState() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _containerDecoration(),
      child: const Center(
        child: Text(
          "Audio unavailable",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: _containerDecoration(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPlayPauseButton(),
          const SizedBox(width: 8),
          Expanded(child: _buildWaveform()),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
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
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : Icon(
                controller.mediaController.isPlaying.value
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                color: Colors.white,
                size: 30,
              )),
      ),
    );
  }

  Widget _buildWaveform() {
    return Obx(() {
      final audioController = controller.mediaController.audioController;
      
      if (audioController == null) {
        return Container(
          height: 40,
          width: 100,
          alignment: Alignment.center,
          child: Container(
            height: 2,
            color: Colors.white54,
          ),
        );
      }

      return AudioFileWaveforms(
        playerController: audioController,
        size: Size(Get.width * 0.4, 40),
        playerWaveStyle: const PlayerWaveStyle(
          fixedWaveColor: Colors.white54,
          liveWaveColor: Colors.white,
          spacing: 6,
          waveThickness: 2,
        ),
        enableSeekGesture: true,
        continuousWaveform: true,
        waveformType: WaveformType.fitWidth,
      );
    });
  }

  BoxDecoration _containerDecoration() {
    return BoxDecoration(
      color: Colors.black.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
    );
  }
}