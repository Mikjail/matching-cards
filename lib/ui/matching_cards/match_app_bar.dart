import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class MatchAppBar extends StatelessWidget {
  final void Function() onCountdownFinished;

  const MatchAppBar({
    super.key,
    required CountDownController controller,
    required this.numberOfMatches,
    required this.onCountdownFinished,
  }) : _controller = controller;

  final CountDownController _controller;
  final int numberOfMatches;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80,
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 70.0,
          height: 70.0,
          child: CircularCountDownTimer(
            duration: 30,
            initialDuration: 0,
            controller: _controller,
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 2,
            ringColor: Colors.grey[300]!,
            ringGradient: null,
            fillColor: Color.fromARGB(255, 180, 0, 186),
            fillGradient: null,
            backgroundGradient: null,
            strokeWidth: 4.0,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textFormat: CountdownTextFormat.S,
            isReverse: false,
            isReverseAnimation: false,
            isTimerTextShown: true,
            autoStart: false,
            onStart: () {
              debugPrint('Countdown Started');
            },
            onComplete: onCountdownFinished,
            onChange: (String timeStamp) {
              debugPrint('Countdown Changed $timeStamp');
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              return 30 - duration.inSeconds;
            },
          ),
        ),
        SizedBox(
          width: 80,
          child: Text(
            'Matches: ${numberOfMatches.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
