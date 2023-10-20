import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/start_screen.dart';

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
  final contdownDuration = 30;

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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StartScreen()));
              },
              color: CustomTheme.white,
            ),
          ),
        ),
        countDown(contdownDuration, _controller, onCountdownFinished, context),
        SizedBox(
          width: 80,
          child: Text(
            'Matches: ${numberOfMatches.toString()}',
            style: TextStyle(color: CustomTheme.white),
          ),
        ),
      ],
    );
  }
}

Widget countDown(
  int contdownDuration,
  CountDownController controller,
  void Function() onCountdownFinished,
  BuildContext context,
) {
  return SizedBox(
    width: 70.0,
    height: 70.0,
    child: CircularCountDownTimer(
      duration: contdownDuration,
      initialDuration: 0,
      controller: controller,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      ringColor: CustomTheme.blue,
      ringGradient: null,
      fillColor: CustomTheme.lightGray,
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
        return contdownDuration - duration.inSeconds;
      },
    ),
  );
}
