import 'package:of_card_match/matching_cards/matching_cards.dart';

class MatchingCardBoard {
  final List<dynamic> cards;
  List<dynamic> _selectedCards = [];
  int numberOfMatches = 0;

  MatchingCardBoard({required this.cards});

  _shuffleCards() {
    cards.shuffle();
  }

  pickRandomCards(int count) {
    _shuffleCards();
    _selectedCards = cards.take(count).toList();
  }

  refillCard() {
    _shuffleCards();
    _selectedCards.add(cards.first);
    return cards.first;
  }

  getShuffledCardsFromKey(String key) {
    final shuffled = _selectedCards
        .map((e) => {'name': e[key], 'status': MatchStatus.reset})
        .toList();
    shuffled.shuffle();
    return shuffled;
  }

  bool isMatch(String left, String right) {
    return _selectedCards.firstWhere(
          (card) => card['team'] == left && card['player'] == right,
          orElse: () => null,
        ) !=
        null;
  }

  removeFromSelectedCards(String left, String right) {
    _selectedCards.removeWhere(
      (card) => card['team'] == left && card['player'] == right,
    );
  }
}

class Card {
  final String team;
  final String player;

  Card({required this.team, required this.player});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      team: json['team'],
      player: json['player'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'team': team,
      'player': player,
    };
  }
}
