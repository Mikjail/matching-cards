import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:of_card_match/domain/players.dart';
import 'package:of_card_match/domain/players_repository.dart';

import 'dart:io';

import 'matching_card_repository_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group('fetchMatchList', () {
    test('returns a list of Matches if the http call completes successfully',
        () async {
      final client = MockClient();
      final file = File('assets/mocks/worldcup.json');
      final jsonString = await file.readAsString();

      when(client.get(Uri.parse(
              'https://scores-api.onefootball.com/v1/en/competitions/12/players/top?size=50')))
          .thenAnswer((_) async => http.Response(jsonString, 200, headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      final repository = PlayersRepository(client);

      expect(await repository.getTopPlayersFromCompetition('12'),
          isA<List<PlayerCard>>());
    });
  });
}
