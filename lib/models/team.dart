import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class MatchingCardBoard {
  final List<MatchCard> cards;
  List<MatchCard> _selectedCards = [];
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

  getShuffledCardsFromTeams() {
    final shuffled = _selectedCards
        .map((card) =>
            {'name': card.team, 'status': MatchStatus.reset, 'selected': false})
        .toList();
    shuffled.shuffle();
    return shuffled;
  }

  getShuffledCardsFromPlayers() {
    final shuffled = _selectedCards
        .map((card) => {
              'name': card.player,
              'status': MatchStatus.reset,
              'selected': false
            })
        .toList();
    shuffled.shuffle();
    return shuffled;
  }

  MatchStatus getStatus(String left, String right) {
    final MatchCard card = _selectedCards.firstWhere(
      (card) => card.team == left && card.player == right,
      orElse: () => MatchCard(
        id: '',
        team: '',
        player: '',
        imgPlayer: '',
        imgTeam: '',
      ),
    );
    return card.id != '' ? MatchStatus.match : MatchStatus.noMatch;
  }

  removeFromSelectedCards(String left, String right) {
    _selectedCards.removeWhere(
      (card) => card.team == left && card.player == right,
    );
  }
}

class MatchCard {
  final String id;
  final String team;
  final String player;
  final String imgPlayer;
  final String imgTeam;

  MatchCard({
    required this.id,
    required this.team,
    required this.player,
    required this.imgPlayer,
    required this.imgTeam,
  });

  factory MatchCard.fromJson(Map<String, dynamic> json) {
    return MatchCard(
      id: json['id'].toString(),
      team: json['nationalTeam']['name'],
      player: json['name'],
      imgPlayer: json['imageSrc'],
      imgTeam: json['nationalTeam']['logoUrls'][0]['url'],
    );
  }
}
