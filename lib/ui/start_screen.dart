import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class Competition {
  final String id;
  final String name;
  final String logo;
  final String alt;

  Competition({
    required this.id,
    required this.name,
    required this.logo,
    required this.alt,
  });
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              begin: Alignment(0.00, 5.00),
              end: Alignment(0, -0.99),
              colors: [Color(0xEAD7FF47), Color(0x00D7FF47)],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'OF Card Match',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        'The objective of the game is to match players with teams!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomTheme.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: Image.asset("assets/imgs/quiz-badge.png",
                          width: 130, height: 130),
                    ),
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
                        GoRouter.of(context).go('/matchingCards/12/v2');
                      },
                      child: Text(
                        'Play',
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

//
