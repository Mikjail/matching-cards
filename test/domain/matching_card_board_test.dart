import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:of_card_match/domain/matching_card.dart';
import 'package:of_card_match/domain/matching_card_board.dart';
import 'package:of_card_match/domain/players.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

void main() {
  final List<Player> players = [
    Player(
      id: 1,
      team: 'team1',
      player: 'player1',
      imgPlayer: 'imgPlayer1',
      imgTeam: 'imgTeam1',
    ),
    Player(
      id: 2,
      team: 'team2',
      player: 'player2',
      imgPlayer: 'imgPlayer2',
      imgTeam: 'imgTeam2',
    ),
    Player(
      id: 3,
      team: 'team3',
      player: 'player3',
      imgPlayer: 'imgPlayer3',
      imgTeam: 'imgTeam3',
    ),
    Player(
      id: 4,
      team: 'team4',
      player: 'player4',
      imgPlayer: 'imgPlayer4',
      imgTeam: 'imgTeam4',
    ),
    Player(
      id: 5,
      team: 'team5',
      player: 'player5',
      imgPlayer: 'imgPlayer5',
      imgTeam: 'imgTeam5',
    ),
    Player(
      id: 6,
      team: 'team6',
      player: 'player6',
      imgPlayer: 'imgPlayer6',
      imgTeam: 'imgTeam6',
    ),
    Player(
      id: 7,
      team: 'team7',
      player: 'player7',
      imgPlayer: 'imgPlayer7',
      imgTeam: 'imgTeam7',
    ),
    Player(
      id: 8,
      team: 'team8',
      player: 'player8',
      imgPlayer: 'imgPlayer8',
      imgTeam: 'imgTeam8',
    ),
  ];
  final matchingCardBoard = MatchingCardBoard(cardsDeck: players);
  setUp(() {
    matchingCardBoard.startGame(4);
  });

  test(
      'When a game is started I should be able to select the number of cards to play',
      () {
    expect(matchingCardBoard.selectedPlayers.length, 4);
  });

  test(
      'After a game is started I should be able to get 4 Matching Cards based with the name based on a Team',
      () {
    final matchCards = matchingCardBoard.getShuffledCardsBasedOnTeams();
    final teamNames = players.map((card) => card.team).toList();
    expect(matchCards.length, 4);
    expect(matchCards.first.name, anyOf(teamNames));
  });

  test(
      'After a game is started is started I should be able to get 4 Matching Cards with the name based on a Player',
      () {
    final matchCards = matchingCardBoard.getShuffledCardsBasedOnPlayers();
    final playerNames = players.map((card) => card.player).toList();
    expect(matchCards.length, 4);
    expect(matchCards.first.name, anyOf(playerNames));
  });

  test(
      'When a game is started and two matching cards are selected I should be able to get a MatchStatus.match',
      () {
    final leftCard = MatchingCard(
        id: 1, name: 'team1', status: MatchStatus.visible, selected: false);
    final rightCard = MatchingCard(
        id: 1, name: 'player1', status: MatchStatus.visible, selected: false);
    final status = matchingCardBoard.checkMatch(leftCard, rightCard);
    expect(status, MatchStatus.match);
  });

  test(
      'When a game is started and two unmatching cards are selected I should be able to get a MatchStatus.noMatch',
      () {
    final leftCard = MatchingCard(
        id: 1, name: 'team1', status: MatchStatus.visible, selected: false);
    final rightCard = MatchingCard(
        id: 2, name: 'player2', status: MatchStatus.visible, selected: false);
    final status = matchingCardBoard.checkMatch(leftCard, rightCard);
    expect(status, MatchStatus.noMatch);
  });

  test(
      'When there is 2 matching cards I should be able to delete them from the selectedList',
      () async {
    final card = matchingCardBoard.getShuffledCardsBasedOnTeams().first;
    matchingCardBoard.removeFromSelectedCards(card);
    expect(matchingCardBoard.selectedPlayers.length, 3);
  });
}
