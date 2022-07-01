import 'dart:async';

Future<Timer> interval(Duration duration, Future Function(Timer?) func) async {
  await func(null);

  Timer function() {
    Timer timer = Timer(duration, function);

    func(timer);

    return timer;
  }

  return Timer(duration, function);
}
