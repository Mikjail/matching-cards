import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:of_card_match/locator.dart';
import 'package:of_card_match/services/matching_card_service.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';
import 'dart:convert';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'matching_card_test.mocks.dart';

class MockMatchingCardService extends Mock implements MatchingCardService {}

@GenerateMocks([
  HttpClient,
  HttpClientRequest,
  HttpClientResponse,
  HttpHeaders,
])
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return mockHttpClient;
  }
}

final mockHttpClient = MockHttpClient();

setUpMockHttpClien() async {
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

    await setUpMockHttpClien();
  });

  testWidgets('Grid item tap updates state', (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      await tester.pumpWidget(
        const MaterialApp(
          title: 'OneFootball - Matching Cards',
          home: Material(
            child: MatchingCards(key: Key('myMatchingGrid')),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));
      // Check initial state
      expect(myWidgetState.prevLeftSelection, null);
      expect(myWidgetState.prevRightSelection, null);

      // set gameStarted to true
      myWidgetState.setState(() {
        myWidgetState.gameStarted = true;
      });

      await tester.pumpAndSettle();

      const index = 3;
      // Tap a card inside the left grid
      await tester.tap(find.byKey(const Key('leftCard-$index')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Access the state of the widget and verify that the state is updated
      expect(myWidgetState.leftList[index]['selected'], isTrue);

      await tester.tap(find.byKey(const Key('rightCard-$index')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(myWidgetState.rightList[index]['selected'], isTrue);
    });
  });

  testWidgets('When two tapped cards match then status of the cards is match',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      final materialApp = makeSut();
      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));

      final myWidgetState = tester
          .state<MatchingCardsState>(find.byKey(const Key('myMatchingGrid')));

      // Check initial state
      expect(myWidgetState.prevLeftSelection, null);
      expect(myWidgetState.prevRightSelection, null);

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
      final leftCard = myWidgetState.leftList
          .firstWhere((element) => element['selected'] == true);
      final rightCard = myWidgetState.rightList
          .firstWhere((element) => element['selected'] == true);
      expect(leftCard['selected'], isTrue);
      expect(rightCard['selected'], isTrue);
      expect(leftCard['status'], MatchStatus.match);
      expect(leftCard['status'], MatchStatus.match);
    });
  });

  testWidgets(
      'When two tapped cards dont match their status changes to noMatch',
      (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      final materialApp = makeSut();
      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));

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
          myWidgetState.leftList.firstWhere((card) => card['name'] == 'Brazil');
      var rightCard = myWidgetState.rightList
          .firstWhere((card) => card['name'] == 'Cristiano Ronaldo');

      expect(leftCard['status'], MatchStatus.reset);
      expect(rightCard['status'], MatchStatus.reset);

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

      expect(leftCard['status'], MatchStatus.noMatch);
      expect(rightCard['status'], MatchStatus.noMatch);
    });
  });
}

class MockMathingCardService extends Mock implements MatchingCardService {}

Widget makeSut() {
  return const MaterialApp(
    title: 'OneFootball - Matching Cards',
    home: MatchingCards(key: Key('myMatchingGrid')),
  );
}

Future<void> adjustSize() async {
  const double portraitWidth = 400.0;
  const double portraitHeight = 800.0;
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  await binding.setSurfaceSize(const Size(portraitWidth, portraitHeight));
}
