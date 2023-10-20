import 'package:of_card_match/domain/matching_card.dart';
import 'package:of_card_match/domain/players.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class MatchingCardBoard {
  final int points = 10;
  final int bonusPoints = 15;
  final List<PlayerCard> cardDeck;
  int _numberOfMatches = 0;
  int _numberOfConsecutiveMatch = 0;
  List<PlayerCard> _selectedCards = [];

  get numberOfMatches => _numberOfMatches;
  get selectedCards => _selectedCards;
  get numberOfConsecutiveMatch => _numberOfConsecutiveMatch;

  MatchingCardBoard({required this.cardDeck});

  void _shuffleCards() {
    cardDeck.shuffle();
  }

  void startGame(int count) {
    _shuffleCards();
    _selectedCards = cardDeck.take(count).toList();
  }

  void refillCard() {
    _selectedCards.add(cardDeck.first);
  }

  List<MatchingCard> getShuffledCardsBasedOnTeams() {
    final cards = _selectedCards
        .map((player) => MatchingCard(
            id: player.id,
            name: player.team,
            status: MatchStatus.visible,
            selected: false,
            imageUrl: player.imgTeam,
            isPlayer: false))
        .toList();
    cards.shuffle();
    return cards;
  }

  List<MatchingCard> getShuffledCardsBasedOnPlayers() {
    final cards = _selectedCards
        .map((player) => MatchingCard(
            id: player.id,
            name: player.player,
            status: MatchStatus.visible,
            selected: false,
            imageUrl: player.imgPlayer,
            isPlayer: true))
        .toList();
    cards.shuffle();
    return cards;
  }

  MatchStatus checkMatch(MatchingCard left, MatchingCard right) {
    final card = _selectedCards.firstWhere(
      (card) => card.team == left.name && card.player == right.name,
      orElse: () => PlayerCard(
        id: -1,
        team: '',
        player: '',
        imgPlayer: '',
        imgTeam: '',
      ),
    );
    return card.id == -1 ? MatchStatus.noMatch : MatchStatus.match;
  }

  bool isCardVisible(MatchingCard card) {
    return card.status == MatchStatus.visible;
  }

  void removeFromSelectedCards(MatchingCard leftCard, MatchingCard rightCard) {
    _selectedCards.removeWhere((player) =>
        leftCard.name == player.team && rightCard.name == player.player);
  }

  void setMatchPoints(bool isMatch) {
    if (isMatch) {
      _numberOfMatches += 1;
      _numberOfConsecutiveMatch += 1;
    } else {
      _numberOfConsecutiveMatch = 0;
    }
  }

  int calculateScore() {
    if (_numberOfConsecutiveMatch > 1) {
      return points + bonusPoints;
    }
    return points;
  }
}
