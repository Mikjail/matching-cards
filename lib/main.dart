import 'package:flutter/material.dart';
import 'package:of_card_match/locator.dart';
import 'package:of_card_match/matching_cards/matching_cards.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(title, style: const TextStyle(color: Colors.white)),
          shape: const Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        body: const MatchingGrid(
          key: Key('myMatchingGrid'),
        ),
      ),
    );
  }
}
