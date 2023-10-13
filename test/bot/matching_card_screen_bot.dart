import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class CardMatchBot {
  final WidgetTester _tester;
  late MatchingCardsState _myWidgetState;

  CardMatchBot(this._tester);

  get widgetState => _myWidgetState;

  Future<void> showBoard() async {
    await adjustSize();

    final materialApp = makeSut();

    await _tester.pumpWidget(materialApp);

    await _tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> startGame() async {
    _myWidgetState = _tester
        .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

    // set gameStarted to true
    _myWidgetState.setState(() {
      _myWidgetState.gameStarted = true;
    });

    await _tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> tapCard(String text) async {
    await _tester.tap(find.text(text));
    await _tester.pump();
  }
}

Widget makeSut() {
  return const MaterialApp(
    title: 'OneFootball - Matching Cards',
    home: MatchingCards(key: Key('myMatchingGrid'), competitionId: '12'),
  );
}

Future<void> adjustSize() async {
  const double portraitWidth = 400.0;
  const double portraitHeight = 800.0;
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  await binding.setSurfaceSize(const Size(portraitWidth, portraitHeight));
}
