import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:of_card_match/theme/colors.dart';

class MatchAppBar extends StatelessWidget {
  final void Function() onCountdownFinished;

  const MatchAppBar({
    super.key,
    required CountDownController controller,
    required this.score,
    required this.onCountdownFinished,
  }) : _controller = controller;

  final CountDownController _controller;
  final int score;
  final contdownDuration = 30;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              color: CustomTheme.white,
            ),
          ),
        ),
        countDown(contdownDuration, _controller, onCountdownFinished, context),
        Row(children: [
          Image.asset(
            'assets/imgs/score.png',
            fit: BoxFit.contain,
            width: 50,
          ),
          SizedBox(
            width: 90,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CustomTheme.scoreBackground,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                score.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomTheme.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
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
    width: 80.0,
    height: 80.0,
    child: CircularCountDownTimer(
      duration: contdownDuration,
      initialDuration: 0,
      controller: controller,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      ringColor: CustomTheme.grey,
      ringGradient: null,
      fillColor: CustomTheme.white,
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
