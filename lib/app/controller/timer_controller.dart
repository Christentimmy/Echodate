

import 'dart:async';
import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt secondsRemaining = 30.obs;
  late Timer timer;


  @override
  onInit(){
    super.onInit();
    startTimer();
  }

  @override
  onClose(){
    super.onClose();
    timer.cancel();
  }

  void startTimer() {
    secondsRemaining.value = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (timer){
      if (secondsRemaining.value < 1) {
        timer.cancel();
      }else{
        secondsRemaining--;
      }
    });
  }
}