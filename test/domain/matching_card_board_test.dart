import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/domain/matching_card.dart';
import 'package:of_card_match/domain/matching_card_board.dart';
import 'package:of_card_match/domain/players.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

void main() {
  final List<PlayerCard> players = [
    PlayerCard(
      id: 1,
      team: 'team1',
      player: 'player1',
      imgPlayer: 'imgPlayer1',
      imgTeam: 'imgTeam1',
    ),
    PlayerCard(
      id: 2,
      team: 'team2',
      player: 'player2',
      imgPlayer: 'imgPlayer2',
      imgTeam: 'imgTeam2',
    ),
    PlayerCard(
      id: 3,
      team: 'team3',
      player: 'player3',
      imgPlayer: 'imgPlayer3',
      imgTeam: 'imgTeam3',
    ),
    PlayerCard(
      id: 4,
      team: 'team4',
      player: 'player4',
      imgPlayer: 'imgPlayer4',
      imgTeam: 'imgTeam4',
    ),
    PlayerCard(
      id: 5,
      team: 'team5',
      player: 'player5',
      imgPlayer: 'imgPlayer5',
      imgTeam: 'imgTeam5',
    ),
    PlayerCard(
      id: 6,
      team: 'team6',
      player: 'player6',
      imgPlayer: 'imgPlayer6',
      imgTeam: 'imgTeam6',
    ),
    PlayerCard(
      id: 7,
      team: 'team7',
      player: 'player7',
      imgPlayer: 'imgPlayer7',
      imgTeam: 'imgTeam7',
    ),
    PlayerCard(
      id: 8,
      team: 'team8',
      player: 'player8',
      imgPlayer: 'imgPlayer8',
      imgTeam: 'imgTeam8',
    ),
  ];
  var matchingCardBoard;
  const cardsToPlay = 4;

  setUp(() {
    matchingCardBoard = MatchingCardBoard(cardDeck: players);
    matchingCardBoard.startGame(cardsToPlay);
  });

  test(
      'When a game has started there should be the same number of cards selected as the number of cards to play',
      () {
    expect(matchingCardBoard.selectedCards.length, cardsToPlay);
  });

  test(
      'When a game has started I should be able to get 4 Cards based on a Team name',
      () {
    final matchCards = matchingCardBoard.getShuffledCardsBasedOnTeams();
    final teamNames = players.map((card) => card.team).toList();
    expect(matchCards.length, 4);
    expect(matchCards.first.name, anyOf(teamNames));
  });

  test(
      'When a game has started I should be able to get 4 Cards based on a Player name',
      () {
    final matchCards = matchingCardBoard.getShuffledCardsBasedOnPlayers();
    final playerNames = players.map((card) => card.player).toList();
    expect(matchCards.length, 4);
    expect(matchCards.first.name, anyOf(playerNames));
  });

  test(
      'When 2 matching cards are selected I should be able to get a MatchStatus.match',
      () {
    final leftCard = MatchingCard(
        id: 1, name: 'team1', status: MatchStatus.visible, selected: false);
    final rightCard = MatchingCard(
        id: 1, name: 'player1', status: MatchStatus.visible, selected: false);
    final status = matchingCardBoard.checkMatch(leftCard, rightCard);
    expect(status, MatchStatus.match);
  });

  test(
      'When 2 unmatching cards are selected I should be able to get a MatchStatus.noMatch',
      () {
    final leftCard = MatchingCard(
        id: 1, name: 'team1', status: MatchStatus.visible, selected: false);
    final rightCard = MatchingCard(
        id: 2, name: 'player2', status: MatchStatus.visible, selected: false);
    final status = matchingCardBoard.checkMatch(leftCard, rightCard);
    expect(status, MatchStatus.noMatch);
  });

  test(
      'When there is 2 matching cards I should be able to from the selected cards',
      () async {
    final card = matchingCardBoard.getShuffledCardsBasedOnTeams().first;
    matchingCardBoard.removeFromSelectedCards(card);
    expect(matchingCardBoard.selectedCards.length, 3);
  });

  test(
      'when there is 1 match the number of matches and consecutive matches should increase to 1',
      () {
    const isMatch = true;
    matchingCardBoard.setMatchPoints(isMatch);
    expect(matchingCardBoard.numberOfMatches, 1);
    expect(matchingCardBoard.numberOfConsecutiveMatch, 1);
  });

  test('when there is 1 match the score should be 10points', () {
    const isMatch = true;
    matchingCardBoard.setMatchPoints(isMatch);
    expect(matchingCardBoard.calculateScore(), 10);
  });

  test(
      'when there is >1 consecutive match, the score should be 10points + 15points',
      () {
    const isMatch = true;
    matchingCardBoard.setMatchPoints(isMatch); // 10points
    matchingCardBoard.setMatchPoints(isMatch); // 10points + 15points
    expect(matchingCardBoard.calculateScore(), 25);
  });
}
