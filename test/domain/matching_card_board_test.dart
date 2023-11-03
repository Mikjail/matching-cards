import 'dart:io';
import 'dart:math';

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
  ];
  late MatchingCardBoard matchingCardBoard;
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
        id: 1,
        name: 'team1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');
    final rightCard = MatchingCard(
        id: 1,
        name: 'player1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');
    final status = matchingCardBoard.checkMatch(leftCard, rightCard);
    expect(status, MatchStatus.match);
  });

  test(
      'When 2 unmatching cards are selected I should be able to get a MatchStatus.noMatch',
      () {
    final leftCard = MatchingCard(
        id: 1,
        name: 'team1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');
    final rightCard = MatchingCard(
        id: 2,
        name: 'player2',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');
    final status = matchingCardBoard.checkMatch(leftCard, rightCard);
    expect(status, MatchStatus.noMatch);
  });

  test(
      'GIVEN 2 cards WHEN they match and the board remove the card THEN the board should add the remain missing card in the backup cards',
      () async {
    final leftCard = MatchingCard(
        id: 1,
        name: 'team1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');
    final rightCard = MatchingCard(
        id: 2,
        name: 'player1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');

    matchingCardBoard.removeFromSelectedCards(leftCard, rightCard);

    matchingCardBoard.addBackupCards();

    expect(matchingCardBoard.backUpCards.length, 1);
  });

  test(
      'GIVEN 2 cards WHEN they match THEN the board should remove the card from selected cards',
      () async {
    final leftCard = MatchingCard(
        id: 1,
        name: 'team1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');
    final rightCard = MatchingCard(
        id: 2,
        name: 'player1',
        status: MatchStatus.visible,
        selected: false,
        imageUrl: '');

    matchingCardBoard.removeFromSelectedCards(leftCard, rightCard);

    expect(matchingCardBoard.selectedCards.length, 3);
  });

  test(
      'GIVEN 2 cards WHEN they are hidden THEN the board should be able to replace them with new visible cards',
      () async {
    final cards = [
      PlayerCard(
        id: 5,
        team: 'team5',
        player: 'player5',
        imgPlayer: 'imgPlayer5',
        imgTeam: 'imgTeam1',
      ),
      PlayerCard(
        id: 6,
        team: 'team6',
        player: 'player6',
        imgPlayer: 'imgPlayer6',
        imgTeam: 'imgTeam6',
      )
    ];

    final leftCard = MatchingCard(
        id: 1,
        name: 'team1',
        status: MatchStatus.hidden,
        selected: false,
        imageUrl: '');
    final rightCard = MatchingCard(
        id: 2,
        name: 'player1',
        status: MatchStatus.hidden,
        selected: false,
        imageUrl: '');

    final mockData = [...players, ...cards];

    final matchingCardBoard = MatchingCardBoard(cardDeck: mockData);

    matchingCardBoard.removeFromSelectedCards(leftCard, rightCard);

    matchingCardBoard.addBackupCards();

    final newCards =
        matchingCardBoard.replaceHiddenCards([leftCard, rightCard]);

    expect(newCards.first.status, MatchStatus.visible);
    expect(newCards.last.status, MatchStatus.visible);
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

  test(
      'GIVEN 4 Matching cards WHEN there are hidden cards THEN it should be able to replace them with new visible cards',
      () {
    //create a new Matching card board with 2 extra cards.
    final cards = [
      PlayerCard(
        id: 5,
        team: 'team5',
        player: 'player5',
        imgPlayer: 'imgPlayer5',
        imgTeam: 'imgTeam1',
      ),
      PlayerCard(
        id: 6,
        team: 'team6',
        player: 'player6',
        imgPlayer: 'imgPlayer6',
        imgTeam: 'imgTeam6',
      )
    ];
    final mockData = [...players, ...cards];
    final matchingCardBoard = MatchingCardBoard(cardDeck: mockData);

    // pass 4 cards to the board
    matchingCardBoard.startGame(4);

    // all cards should be hidden
    final cardsLeft = matchingCardBoard.getShuffledCardsBasedOnTeams();
    final cardsRight = matchingCardBoard.getShuffledCardsBasedOnTeams();

    final newCards =
        matchingCardBoard.replaceHiddenCards([...cardsLeft, ...cardsRight]);

    // all cards should be visible now
    expect(newCards.every((card) => card.status == MatchStatus.visible), true);
  });
}
