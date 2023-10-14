import 'dart:convert';
import 'package:http/http.dart';
import 'package:of_card_match/domain/players.dart';
import 'package:of_card_match/domain/players_repository_interface.dart';

class PlayersRepository implements IPlayersRepository {
  final Client client;

  PlayersRepository(this.client);

  @override
  Future<List<PlayerCard>> getTopPlayersFromCompetition(
      String competitionId) async {
    final response = await client.get(Uri.parse(
        'https://scores-api.onefootball.com/v1/en/competitions/$competitionId/players/top?size=50'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final List<PlayerCard> list = data
          .map<PlayerCard>((player) => PlayerCard.fromJson(player))
          .toList();

      return list;
    } else {
      throw Exception('Failed to load matching cards');
    }
  }
}
