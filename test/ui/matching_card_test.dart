import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:of_card_match/domain/matching_card_board.dart';

import 'package:of_card_match/locator.dart';
import 'package:of_card_match/ui/matching_cards/custom_card.dart';

import 'package:of_card_match/ui/matching_cards/matching_cards.dart';
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
import '../bot/matching_card_screen_bot.dart';
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
  setUp(() async {
    setUpLocator();

    HttpOverrides.global = MockHttpOverrides();

    await setUpMockHttpClient();
  });

  testWidgets('When the widget is loaded it should display two gridViews',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await adjustSize();

    await cardMatchBot.showBoard();

    // Verify initial state
    expect(find.byType(GridView), findsNWidgets(2));
  });

  testWidgets('When the widget is loaded it should display 4 in each gridView',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    // Left Custom Cards
    final leftCustomCards = find.descendant(
      of: find.byType(GridView).first,
      matching: find.byType(CustomCard),
    );

    expect(leftCustomCards, findsNWidgets(4));

    // Right Custom Cards
    final rightCustomCards = find.descendant(
      of: find.byType(GridView).last,
      matching: find.byType(CustomCard),
    );

    expect(rightCustomCards, findsNWidgets(4));
  });

  testWidgets(
      'When the widget is loaded and the game has not started the customCards should be disabled',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    final customCardFinder = find.byType(CustomCard).first;

    for (int i = 0; i < customCardFinder.evaluate().length; i++) {
      final CustomCard customCard = tester.widget(customCardFinder.at(i));
      expect(customCard.disabled, isTrue);
    }
  });

  testWidgets(
      'When the game started the left and right cards should be on visible status before being taped',
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

      expect(leftCard.status, MatchStatus.visible);
      expect(rightCard.status, MatchStatus.visible);
    });
  });

  testWidgets(
      'When the widget is loaded and the gameStarted I should be able to tap on left and right cards',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      await cardMatchBot.tapCard(const Key('leftCard-134'));

      await cardMatchBot.tapCard(const Key('rightCard-134'));

      final leftCard = cardMatchBot.widgetState.leftList
          .firstWhere((element) => element.selected == true);
      final rightCard = cardMatchBot.widgetState.rightList
          .firstWhere((element) => element.selected == true);

      expect(leftCard.selected, isTrue);
      expect(rightCard.selected, isTrue);
    });
  });

  testWidgets(
      'When the game started and two tapped cards match then status of the cards are match',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      await cardMatchBot.tapCard(const Key('leftCard-134'));

      await cardMatchBot.tapCard(const Key('rightCard-134'));

      final leftCard = cardMatchBot.widgetState.leftList
          .firstWhere((element) => element.selected == true);
      final rightCard = cardMatchBot.widgetState.rightList
          .firstWhere((element) => element.selected == true);

      expect(leftCard.status, MatchStatus.match);
      expect(rightCard.status, MatchStatus.match);
    });
  });

  testWidgets(
      'When two tapped cards dont match their status of the cards are noMatch',
      (tester) async {
    await tester.runAsync(() async {
      final cardMatchBot = CardMatchBot(tester);

      await cardMatchBot.showBoard();

      await cardMatchBot.startGame();

      await cardMatchBot.tapCard(const Key('leftCard-134'));

      await cardMatchBot.tapCard(const Key('rightCard-823'));

      final leftCard = cardMatchBot.widgetState.leftList
          .firstWhere((element) => element.selected == true);
      final rightCard = cardMatchBot.widgetState.rightList
          .firstWhere((element) => element.selected == true);

      expect(leftCard.status, MatchStatus.noMatch);
      expect(rightCard.status, MatchStatus.noMatch);
    });
  });

  testWidgets(
      'GIVEN more than 1 matching card WHEN 1 second pass THEN board should change the status of the cards to hidden',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    await cardMatchBot.startGame();

    await cardMatchBot.tapCard(const Key('leftCard-134'));

    await cardMatchBot.tapCard(const Key('rightCard-134'));

    // delay for 1 second
    await tester.pump(const Duration(seconds: 1));

    // Acccess the cards and check if they are hidden
    final leftCard = cardMatchBot.widgetState.leftList
        .firstWhere((element) => element.id == 134);
    final rightCard = cardMatchBot.widgetState.rightList
        .firstWhere((element) => element.id == 134);

    expect(leftCard.status, MatchStatus.hidden);
    expect(rightCard.status, MatchStatus.hidden);
  });

  testWidgets(
      'GIVEN more than 1 matching card WHEN 2 seconds pass THEN the board should replace hidden cards for new visible ones',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    await cardMatchBot.startGame();

    final leftCards = cardMatchBot.widgetState.leftList;

    await cardMatchBot.tapCard(Key('leftCard-${leftCards[0].id.toString()}'),
        duration: 0);

    await cardMatchBot.tapCard(Key('rightCard-${leftCards[0].id.toString()}'),
        duration: 0);

    await cardMatchBot.tapCard(Key('leftCard-${leftCards[1].id.toString()}'),
        duration: 0);

    await cardMatchBot.tapCard(Key('rightCard-${leftCards[1].id.toString()}'),
        duration: 0);

    await cardMatchBot.tapCard(Key('leftCard-${leftCards[2].id.toString()}'),
        duration: 0);

    await cardMatchBot.tapCard(Key('rightCard-${leftCards[2].id.toString()}'),
        duration: 0);

    // delay 2 seconds
    await tester.pump(const Duration(seconds: 8));

    // Acccess the cards and check if the cards are replaced for visible status
    for (var element in cardMatchBot.widgetState.leftList) {
      expect(element.status, MatchStatus.visible);
    }

    for (var element in cardMatchBot.widgetState.rightList) {
      expect(element.status, MatchStatus.visible);
    }
  });

  testWidgets(
      'When there is a non-cosecutive match 10+pts are added to the score',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    await cardMatchBot.startGame();

    await cardMatchBot.tapCard(const Key('leftCard-134'));

    await cardMatchBot.tapCard(const Key('rightCard-134'));

    // Access the state of the widget and verify that the state is updated
    // first match = 10
    // second match = 10 + 15 bonus
    expect(cardMatchBot.widgetState.score, 10);
  });

  testWidgets(
      'When there is a consecutive match the score should be +10 and a +15 bonus = 35pts',
      (tester) async {
    final cardMatchBot = CardMatchBot(tester);

    await cardMatchBot.showBoard();

    await cardMatchBot.startGame();

    await cardMatchBot.tapCard(const Key('leftCard-134'));

    await cardMatchBot.tapCard(const Key('rightCard-134'));

    await cardMatchBot.tapCard(const Key('leftCard-823'));

    await cardMatchBot.tapCard(const Key('rightCard-823'));

    await tester.pump(const Duration(seconds: 1));
    // Access the state of the widget and verify that the state is updated
    // first match = 10
    // second match = 10 + 15 bonus
    expect(cardMatchBot.widgetState.score, 35);
  });
}
