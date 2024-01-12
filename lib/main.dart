import 'package:flutter/material.dart';
import 'package:of_card_match/locator.dart';
import 'package:of_card_match/router.dart';

void main() {
  // Register your service as a singleton
  setUpLocator();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
    );
  }
}
