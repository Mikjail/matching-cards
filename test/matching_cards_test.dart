import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/main.dart';
import 'package:of_card_match/matching_cards/%20custom_card.dart';
import 'package:of_card_match/matching_cards/matching_cards.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.

  testWidgets('Grid item tap updates state', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify initial state
    expect(find.byType(GridView), findsNWidgets(2));

    final myWidgetState = tester
        .state<MatchingGridState>(find.byKey(const Key('myMatchingGrid')));

    // Check initial state
    expect(myWidgetState.leftIndexSelected, null);
    expect(myWidgetState.leftIndexSelected, null);

    // Tap a card inside the left grid
    await tester.tap(find.byType(CustomCard).first);
    await tester.pump();

    // Access the state of the widget and verify that the state is updated
    expect(myWidgetState.leftIndexSelected, 1);
  });
}
