import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/matching_cards/matching_cards.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.

  testWidgets('Grid item tap updates state', (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: MatchingGrid(
      key: Key('myMatchingGrid'),
    )));

    // Verify initial state
    expect(find.byType(GridView), findsNWidgets(2));

    final myWidgetState = tester
        .state<MatchingGridState>(find.byKey(const Key('myMatchingGrid')));

    // Check initial state
    expect(myWidgetState.leftIndexSelected, null);
    expect(myWidgetState.rightIndexSelected, null);

    await tester.dragUntilVisible(find.byKey(const Key('leftCard-2')),
        find.byKey(const Key('leftGrid')), const Offset(0, 100));

    await tester.pumpAndSettle(const Duration(microseconds: 500));

    // Tap a card inside the left grid
    await tester.tap(find.byKey(const Key('leftCard-3')));
    await tester.pump();

    // Access the state of the widget and verify that the state is updated
    expect(myWidgetState.leftIndexSelected, 3);

    await tester.tap(find.byKey(const Key('rightCard-2')));
    await tester.pump();

    expect(myWidgetState.rightIndexSelected, 2);
  });
}
