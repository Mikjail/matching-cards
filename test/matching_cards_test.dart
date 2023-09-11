import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/locator.dart';
import 'package:of_card_match/matching_cards/matching_cards.dart';

void main() {
  setUp(() async {
    setUpLocator();
  });

  tearDown(() {});

  testWidgets('Grid item tap updates state', (tester) async {
    await tester.runAsync(() async {
      await adjustSize();

      final materialApp = makeSut();

      await tester.pumpWidget(materialApp);

      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));

      final myWidgetState = tester
          .state<MatchingGridState>(find.byKey(const Key('myMatchingGrid')));

      // Check initial state
      expect(myWidgetState.leftIndexSelected, null);
      expect(myWidgetState.rightIndexSelected, null);

      // Tap a card inside the left grid
      await tester.tap(find.byKey(const Key('leftCard-3')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Access the state of the widget and verify that the state is updated
      expect(myWidgetState.leftIndexSelected, 3);

      await tester.tap(find.byKey(const Key('rightCard-3')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(myWidgetState.rightIndexSelected, 3);
    });
  });

  testWidgets('When two cards tapped match then isMatch is true',
      (tester) async {
    await tester.runAsync(() async {
      final materialApp = makeSut();
      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));

      final myWidgetState = tester
          .state<MatchingGridState>(find.byKey(const Key('myMatchingGrid')));

      // Check initial state
      expect(myWidgetState.leftIndexSelected, null);
      expect(myWidgetState.rightIndexSelected, null);

      // // tap team (left card)
      await tester.tap(find.text('Argentina'));
      await tester.pump();

      // tap football player (rifght card)
      await tester.tap(find.text('Lionel Messi'));
      await tester.pump();

      // Access the state of the widget and verify that the state is updated
      expect(myWidgetState.leftIndexSelected, isNotNull);
      expect(myWidgetState.rightIndexSelected, isNotNull);
      expect(myWidgetState.leftList[myWidgetState.leftIndexSelected!]['status'],
          MatchStatus.match);
      expect(myWidgetState.leftList[myWidgetState.leftIndexSelected!]['status'],
          MatchStatus.match);
    });
  });

  testWidgets('When two cards tapped dont match their value changed to noMatch',
      (tester) async {
    await tester.runAsync(() async {
      final materialApp = makeSut();
      // Create a new instance of the MatchingGrid widget
      await tester.pumpWidget(materialApp);

      // Wait for the widget tree to settle
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(GridView), findsNWidgets(2));

      var myWidgetState = tester
          .state<MatchingGridState>(find.byKey(const Key('myMatchingGrid')));

      // Check initial state
      // // // Access the state of the widget and verify that the state is updated
      var leftCard =
          myWidgetState.leftList.firstWhere((card) => card['name'] == 'Brasil');
      var rightCard = myWidgetState.rightList
          .firstWhere((card) => card['name'] == 'Luis Suarez');

      expect(leftCard['status'], MatchStatus.reset);
      expect(rightCard['status'], MatchStatus.reset);

      // tap team (left card)
      await tester.tap(find.text('Brasil'));
      await tester.pump();

      // // // tap football player (rifght card)
      await tester.tap(find.text('Luis Suarez'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // Access the state of the widget and verify that the state is updated
      myWidgetState = tester
          .state<MatchingGridState>(find.byKey(const Key('myMatchingGrid')));

      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      expect(leftCard['status'], MatchStatus.noMatch);
      expect(rightCard['status'], MatchStatus.noMatch);
    });
  });
}

Widget makeSut() {
  return const MaterialApp(
    title: 'OneFootball - Matching Cards',
    home: Scaffold(body: MatchingGrid(key: Key('myMatchingGrid'))),
  );
}

Future<void> adjustSize() async {
  const double portraitWidth = 400.0;
  const double portraitHeight = 600.0;
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  await binding.setSurfaceSize(const Size(portraitWidth, portraitHeight));
}
