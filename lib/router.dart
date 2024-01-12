import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:of_card_match/style/my_transition.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/final_score.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';
import 'package:of_card_match/ui/start_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return StartScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'matchingCards/:competitionId/:version',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final competitionId = state.pathParameters['competitionId']!;
            final version = state.pathParameters['version']!;
            return buildMyTransition<void>(
              key: const ValueKey('matchingCards'),
              color: CustomTheme.backgroundPrimary,
              child:
                  MatchingCards(competitionId: competitionId, version: version),
            );
          },
        ),
        GoRoute(
          path: 'finalScore/:score/:totalMatches',
          pageBuilder: (BuildContext context, GoRouterState state) {
            final score = int.parse(state.pathParameters['score']!);
            final totalMatches =
                int.parse(state.pathParameters['totalMatches']!);
            return buildMyTransition<void>(
                key: const ValueKey('finalScore'),
                color: CustomTheme.backgroundPrimary,
                child: FinalScore(
                  score: score,
                  totalMatches: totalMatches,
                ));
          },
        ),
      ],
    ),
  ],
);
