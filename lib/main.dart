import 'package:flutter/material.dart';
import 'package:of_card_match/locator.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';
import 'package:of_card_match/ui/start._screen.dart';

void main() {
  // Register your service as a singleton
  setUpLocator();

  runApp(const MyApp(
    title: 'OneFootball - Matching Cards',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.title});

  final String title;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      routes: {
        '/': (context) => StartScreen(),
        '/matchingCards': (context) => const MatchingCards(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
    );
  }
}
