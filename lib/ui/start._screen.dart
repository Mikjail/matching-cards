import 'package:flutter/material.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MatchingCards()),
            );
          },
          child: const Text('Start Game'),
        ),
      ),
    );
  }
}
