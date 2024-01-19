import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:rive/rive.dart';

class FinalScore extends StatefulWidget {
  final int score;
  final int totalMatches;

  const FinalScore({super.key, this.score = 0, this.totalMatches = 0});

  @override
  State<FinalScore> createState() => _FinalScoreState();
}

class _FinalScoreState extends State<FinalScore>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration:
          const Duration(milliseconds: 1000), // change the duration as needed
      vsync: this,
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Well done!',
                    style: TextStyle(
                      fontSize: 32,
                      color: CustomTheme.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    height: 200,
                    child: RiveAnimation.asset(
                      'assets/rive/award.riv',
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return AnimatedOpacity(
                        opacity: _controller.value,
                        duration: _controller.duration!,
                        child: child,
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'NEW HIGH SCORE:',
                          style: TextStyle(
                            fontSize: 12,
                            color: CustomTheme.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.score}',
                          style: TextStyle(
                            fontSize: 32,
                            color: CustomTheme.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(30), // Adjust the value as needed
                child: SizedBox(
                  width:
                      double.infinity, // Makes the button as wide as its parent
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          CustomTheme.white, // Change this to the desired color
                    ),
                    onPressed: () {
                      GoRouter.of(context).go('/');
                    },
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        color: CustomTheme.backgroundPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
