import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/start_screen.dart';

class FinalScore extends StatelessWidget {
  final int score;
  final int totalMatches;

  const FinalScore({super.key, this.score = 0, this.totalMatches = 0});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Well done!',
                      style: TextStyle(
                        fontSize: 32,
                        color: CustomTheme.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 70),
                    Image.asset(
                      'assets/imgs/award.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 60),
                    Text(
                      'NEW HIGH SCORE:',
                      style: TextStyle(
                        fontSize: 12,
                        color: CustomTheme.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(score.toString(),
                        style: TextStyle(
                          color: CustomTheme.white,
                          decoration: TextDecoration.none,
                          fontSize: 32,
                        )),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.all(30), // Adjust the value as needed
                  child: SizedBox(
                    width: double
                        .infinity, // Makes the button as wide as its parent
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomTheme
                            .white, // Change this to the desired color
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StartScreen(),
                          ),
                        );
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
      ),
    );
  }
}
