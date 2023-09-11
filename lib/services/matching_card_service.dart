import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';

class MatchingCardService {
  Future<List<dynamic>> getMatchingCards() async {
    final String jsonString =
        await rootBundle.loadString('assets/mocks/worldcup.json');

    final List<dynamic> data = await json.decode(jsonString);

    final List<dynamic> list = data
        .expand((team) => team['players']
            .map((player) => {'team': team['team'], 'player': player['name']})
            .toList())
        .toList();

    return list;
  }
}
