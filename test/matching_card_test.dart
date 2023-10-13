import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:of_card_match/locator.dart';

import 'package:of_card_match/ui/matching_cards/matching_cards.dart';
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'bot/matching_card_screen_bot.dart';
import 'matching_card_test.mocks.dart';

@GenerateMocks([
  HttpClient,
  HttpClientRequest,
  HttpClientResponse,
  HttpHeaders,
])
final mockHttpClient = MockHttpClient();

class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return mockHttpClient;
  }
}

setUpMockHttpClient() async {
  final file = File('assets/mocks/worldcup.json');
  final jsonString = await file.readAsString();
  final responseBody = utf8.encode(jsonString);

  when(mockHttpClient.openUrl(any, any)).thenAnswer((invocation) {
    final body = responseBody;
    final request = MockHttpClientRequest();
    final response = MockHttpClientResponse();
    when(request.close()).thenAnswer((_) => Future.value(response));
    when(request.addStream(any)).thenAnswer((_) async => null);
    when(response.headers).thenReturn(MockHttpHeaders());
    when(response.handleError(any, test: anyNamed('test')))
        .thenAnswer((_) => Stream.value(body));
    when(response.statusCode).thenReturn(200);
    when(response.reasonPhrase).thenReturn('OK');
    when(response.contentLength).thenReturn(body.length);
    when(response.isRedirect).thenReturn(false);
    when(response.persistentConnection).thenReturn(false);
    return Future.value(request);
  });
}

void main() {
  var materialApp;

  setUp(() async {
    setUpLocator();

    HttpOverrides.global = MockHttpOverrides();

    await setUpMockHttpClient();
  });

  testWidgets('When the widget is loaded it should display two grids',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    // Verify initial state
    expect(find.byType(GridView), findsNWidgets(2));
  });

  testWidgets(
      'When the widget is loaded and the gameStarted I should be able to tap on left and right cards',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      const index = 3;

      // Tap a card inside the left grid
      await tester.tap(find.byKey(const Key('leftCard-$index')));

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Access the state of the widget and verify that the cards are selected
      expect(cardMatchBot.widgetState.leftList[index].selected, isTrue);

      await tester.tap(find.byKey(const Key('rightCard-$index')));

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(cardMatchBot.widgetState.rightList[index].selected, isTrue);
    });
  });

  testWidgets(
      'When the game started and the left and right cards should be on reset status before being taped',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      // Check the matchStatus on any random left and right cards
      final Random random = Random();
      final int randomIndex =
          random.nextInt(cardMatchBot.widgetState.leftList.length);

      final leftCard = cardMatchBot.widgetState.leftList[randomIndex];
      final rightCard = cardMatchBot.widgetState.rightList[randomIndex];

      expect(leftCard.status, MatchStatus.reset);
      expect(rightCard.status, MatchStatus.reset);
    });
  });

  testWidgets(
      'When the game started and two tapped cards match then status of the cards are match',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      await cardMatchBot.tapCard('Argentina');

      await cardMatchBot.tapCard('Lionel Messi');

      final leftCard = cardMatchBot.widgetState.leftList
          .firstWhere((element) => element.selected == true);
      final rightCard = cardMatchBot.widgetState.rightList
          .firstWhere((element) => element.selected == true);

      expect(leftCard.selected, isTrue);
      expect(rightCard.selected, isTrue);
      expect(leftCard.status, MatchStatus.match);
      expect(leftCard.status, MatchStatus.match);
    });
  });

  testWidgets(
      'When two tapped cards dont match their status should change to noMatch',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      // Check initial state
      // Access the state of the widget and verify that the state is defaulted to reset
      var leftCard = cardMatchBot.widgetState.leftList
          .firstWhere((card) => card.name == 'Brazil');
      var rightCard = cardMatchBot.widgetState.rightList
          .firstWhere((card) => card.name == 'Cristiano Ronaldo');

      await cardMatchBot.tapCard('Brazil');

      await cardMatchBot.tapCard('Cristiano Ronaldo');

      expect(leftCard.status, MatchStatus.noMatch);
      expect(rightCard.status, MatchStatus.noMatch);
    });
  });

  testWidgets(
      'When there is a non-cosecutive match 10+pts are added to the score',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      await cardMatchBot.tapCard('Argentina');

      await cardMatchBot.tapCard('Lionel Messi');

      // Access the state of the widget and verify that the state is updated
      // first match = 10
      // second match = 10 + 15 bonus
      expect(cardMatchBot.widgetState.score, 10);
    });
  });

  testWidgets(
      'When there is a consecutive match the score should be 10+ and a 15+ bonus = 35pts',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      await cardMatchBot.tapCard('Argentina');

      await cardMatchBot.tapCard('Lionel Messi');

      await cardMatchBot.tapCard('Brazil');

      await cardMatchBot.tapCard('Neymar');

      // Access the state of the widget and verify that the state is updated
      // first match = 10
      // second match = 10 + 15 bonus
      expect(cardMatchBot.widgetState.score, 35);
    });
  });
}
