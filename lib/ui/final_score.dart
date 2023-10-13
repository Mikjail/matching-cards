import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/start_screen.dart';

class FinalScore extends StatelessWidget {
  final int score;
  final int totalMatches;

  const FinalScore({super.key, this.score = 0, this.totalMatches = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ' You got $totalMatches matches!',
              style: TextStyle(
                fontSize: 20,
                color: CustomTheme.white,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Final Score',
              style: TextStyle(
                fontSize: 30,
                color: CustomTheme.white,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20),
            Text(score.toString(),
                style: TextStyle(
                  color: CustomTheme.white,
                  decoration: TextDecoration.none,
                )),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                );
              },
              child: const Text('Restart Game'),
            ),
          ],
        ),
      ),
    );
  }
}
