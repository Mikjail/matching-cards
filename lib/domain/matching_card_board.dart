import 'package:of_card_match/domain/matching_card.dart';
import 'package:of_card_match/domain/players.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class MatchingCardBoard {
  final points = 10;
  final bonusPoints = 15;
  final List<Player> cards;
  List<Player> _selectedPlayers = [];
  int numberOfMatches = 0;

  MatchingCardBoard({required this.cards});

  void _shuffleCards() {
    cards.shuffle();
  }

  void pickRandomCards(int count) {
    _shuffleCards();
    _selectedPlayers = cards.take(count).toList();
  }

  void refillCard() {
    _shuffleCards();
    _selectedPlayers.add(cards.first);
  }

  List<MatchingCard> getShuffledCardsBasedOnTeams() {
    final shuffled = _selectedPlayers
        .map((card) => MatchingCard(
            name: card.team, status: MatchStatus.reset, selected: false))
        .toList();
    shuffled.shuffle();
    return shuffled;
  }

  List<MatchingCard> getShuffledCardsBasedOnPlayers() {
    final shuffled = _selectedPlayers
        .map((card) => MatchingCard(
            name: card.player, status: MatchStatus.reset, selected: false))
        .toList();
    shuffled.shuffle();
    return shuffled;
  }

  MatchStatus getStatus(String left, String right) {
    final Player card = _selectedPlayers.firstWhere(
      (card) => card.team == left && card.player == right,
      orElse: () => Player(
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
    _selectedPlayers.removeWhere(
      (card) => card.team == left && card.player == right,
    );
  }
}
