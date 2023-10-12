import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:of_card_match/locator.dart';

import 'package:of_card_match/ui/matching_cards/matching_cards.dart';
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
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

    materialApp = makeSut();
  });

  testWidgets('When the widget is loaded it should display two grids',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      materialApp = makeSut();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));
    });
  });

  testWidgets(
      'When the widget is loaded and the gameStarted I should be able to tap on left and right cards',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      await tester.pumpAndSettle();

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // set gameStarted to true start it
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      const index = 3;
      // Tap a card inside the left grid
      await tester.tap(find.byKey(const Key('leftCard-$index')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Access the state of the widget and verify that the cards are selected
      expect(myWidgetState.leftList[index].selected, isTrue);

      await tester.tap(find.byKey(const Key('rightCard-$index')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(myWidgetState.rightList[index].selected, isTrue);
    });
  });

  testWidgets(
      'When the game started and the left and right cards should be on reset status before being taped',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // set gameStarted to true
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      // Check the matchStatus on any random left and right cards
      final Random random = Random();
      final int randomIndex = random.nextInt(myWidgetState.leftList.length);

      final leftCard = myWidgetState.leftList[randomIndex];
      final rightCard = myWidgetState.rightList[randomIndex];

      expect(leftCard.status, MatchStatus.reset);
      expect(rightCard.status, MatchStatus.reset);
    });
  });

  testWidgets(
      'When the game started and two tapped cards match then status of the cards are match',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // set gameStarted to true
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      // // tap team (left card)
      await tester.tap(find.text('Argentina'));
      await tester.pump();

      // tap football player (rifght card)
      await tester.tap(find.text('Lionel Messi'));
      await tester.pump();

      final leftCard = myWidgetState.leftList
          .firstWhere((element) => element.selected == true);
      final rightCard = myWidgetState.rightList
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
      await adjustSize();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      var myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // set gameStarted to true
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      // Check initial state
      // Access the state of the widget and verify that the state is defaulted to reset
      var leftCard =
          myWidgetState.leftList.firstWhere((card) => card.name == 'Brazil');
      var rightCard = myWidgetState.rightList
          .firstWhere((card) => card.name == 'Cristiano Ronaldo');

      // tap team (left card)
      await tester.tap(find.text('Brazil'));
      await tester.pump();

      // tap football player (rifght card)
      await tester.tap(find.text('Cristiano Ronaldo'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Access the state of the widget and verify that the state is updated to No Match
      myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(leftCard.status, MatchStatus.noMatch);
      expect(rightCard.status, MatchStatus.noMatch);
    });
  });

  testWidgets(
      'When there is a non-cosecutive match 10+pts are added to the score',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // set gameStarted to true
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      // // tap team (left card)
      await tester.tap(find.text('Argentina'));
      await tester.pump();

      // tap football player (rifght card)
      await tester.tap(find.text('Lionel Messi'));
      await tester.pump();

      // Access the state of the widget and verify that the state is updated
      expect(myWidgetState.score, 10);
    });
  });

  testWidgets(
      'When there is a consecutive match the score should be 10+ and a 15+ bonus = 35pts',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // set gameStarted to true
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      // tap team (left card)
      await tester.tap(find.text('Argentina'));
      await tester.pump();

      // tap football player (rifght card)
      await tester.tap(find.text('Lionel Messi'));
      await tester.pump();

      // // tap team (left card)
      await tester.tap(find.text('Brazil'));
      await tester.pump();

      // tap football player (rifght card)
      await tester.tap(find.text('Neymar'));
      await tester.pump();

      // Access the state of the widget and verify that the state is updated
      // first match = 10
      // second match = 10 + 15 bonus
      expect(myWidgetState.score, 35);
    });
  });
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
