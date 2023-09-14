import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class TimerHelper {
  final int countdownDurationInSecond;

  TimerHelper({required this.countdownDurationInSecond});

  Timer? timer;

  void startTimer(VoidCallback callback) {
    timer?.cancel();
    timer = Timer(Duration(seconds: countdownDurationInSecond), callback);
  }
}
