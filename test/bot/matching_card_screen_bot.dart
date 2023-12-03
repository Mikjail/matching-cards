import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/ui/matching_cards/custom_card.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class CardMatchBot {
  final WidgetTester _tester;
  late MatchingCardsState _myWidgetState;

  CardMatchBot(this._tester);

  MatchingCardsState get widgetState => _myWidgetState;

  Future<void> showBoard() async {
    await adjustSize();
    final materialApp = makeSut();
    await _tester.pumpWidget(materialApp);
    await _tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> startGame() async {
    _myWidgetState = _tester
        .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));
    _myWidgetState.setState(() {
      _myWidgetState.gameStarted = true;
    });
    await _tester.pumpAndSettle(const Duration(seconds: 1));
  }

  Future<void> tapCard(String key, {duration = 1000}) async {
    await _tester.tap(find.byWidgetPredicate(
        (widget) => widget is CustomCard && widget.testKey == key));
    await _tester.pump(Duration(milliseconds: duration));
  }

  Future<void> getGrid(String text) async {
    await _tester.tap(find.text(text));
    await _tester.pump(const Duration(seconds: 1));
  }
}

Widget makeSut() {
  return const MaterialApp(
    title: 'OneFootball - Matching Cards',
    home: MatchingCards(
      key: Key('myMatchingGrid'),
      competitionId: '12',
      isTest: true,
    ),
  );
}

Future<void> adjustSize() async {
  const double portraitWidth = 400.0;
  const double portraitHeight = 800.0;
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  await binding.setSurfaceSize(const Size(portraitWidth, portraitHeight));
}
