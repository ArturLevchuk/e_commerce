import 'dart:async';

class TimerService {
  TimerService({required this.onTimer});

  Timer? _timer;
  final Future<void> Function() onTimer;

  void startTimer({required Duration duration}) {
    _timer = Timer(duration, () async {
      await onTimer();
    });
  }

  void stopTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
