import 'dart:async';

class TimerUtil
{
  static Timer startCountdown({
    required int initialCount,
    required void Function(int) onTick,
    required void Function() onComplete,
  })
  {
    int countdown = initialCount;
    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0)
      {
        countdown--;
        onTick(countdown);

      }
      else
      {
        timer.cancel();
        onComplete();
      }
    });
    return timer;
  }
}
