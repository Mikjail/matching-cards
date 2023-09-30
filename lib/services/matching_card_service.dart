import 'dart:convert';
import 'package:http/http.dart';
import 'package:of_card_match/models/team.dart';

class MatchingCardService {
  final Client client;

  MatchingCardService(this.client);

  Future<List<MatchCard>> getMatchingCards() async {
    // final String jsonString =
    //     await rootBundle.loadString('assets/mocks/worldcup.json');

    final response = await client.get(Uri.parse(
        'https://scores-api.onefootball.com/v1/en/competitions/12/players/top?size=50'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final List<MatchCard> list =
          data.map<MatchCard>((player) => MatchCard.fromJson(player)).toList();

      return list;
    } else {
      throw Exception('Failed to load matching cards');
    }
  }
}
