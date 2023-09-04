import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:of_card_match/models/team.dart';

class MatchingCardService {
  Future<List<dynamic>> getMatchingCards() async {
    final String jsonString =
        await rootBundle.loadString('assets/mocks/worldcup.json');

    final List<dynamic> data = json.decode(jsonString);

    final List<dynamic> list = data
        .expand((team) => team['players']
            .map((player) => HashMap.from({team['team']: player['name']}))
            .toList())
        .toList();

    return list;
  }
}
