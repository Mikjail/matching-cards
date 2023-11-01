import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:of_card_match/domain/matching_card.dart';

import 'package:of_card_match/domain/players_repository.dart';
import 'package:of_card_match/ui/final_score.dart';
import 'package:of_card_match/ui/matching_cards/custom_card.dart';
import 'package:of_card_match/domain/matching_card_board.dart';

import 'package:of_card_match/ui/matching_cards/match_app_bar.dart';

import '../../locator.dart';

enum MatchStatus { match, noMatch, hidden, visible }

class MatchingCards extends StatefulWidget {
  final String version;
  final String competitionId;

  const MatchingCards(
      {super.key, this.competitionId = '12', this.version = 'v1'});

  @override
  State<MatchingCards> createState() => MatchingCardsState();
}

class MatchingCardsState extends State<MatchingCards> {
  final playersRepository = locator.get<PlayersRepository>();
  final _controller = CountDownController();
  late MatchingCardBoard matchingCardBoard;
  bool gameStarted = false;
  int score = 0;
  int numberOfMatches = 0;
  int? prevLeftSelection;
  int? prevRightSelection;
  int? leftHeldDown;
  int? rightHeldDown;
  List<MatchingCard> leftList = [];
  List<MatchingCard> rightList = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final players = await playersRepository
        .getTopPlayersFromCompetition(widget.competitionId);
    matchingCardBoard = MatchingCardBoard(cardDeck: players);
    fillCards();
  }

  void startTimer() {
    _controller.start();
    setState(() {
      gameStarted = true;
    });
  }

  void fillCards() {
    matchingCardBoard.startGame(4);
    setState(() {
      leftList = matchingCardBoard.getShuffledCardsBasedOnTeams();
      rightList = matchingCardBoard.getShuffledCardsBasedOnPlayers();
    });
  }

  void onLeftCardTap(int cardIndex) {
    setState(() {
      if (prevLeftSelection != null) {
        leftList[prevLeftSelection!].selected = false;
      }
      prevLeftSelection = cardIndex;
      leftList[cardIndex].selected = true;
    });
    checkMatch();
  }

  void onRightCardTap(int cardIndex) {
    setState(() {
      if (prevRightSelection != null) {
        rightList[prevRightSelection!].selected = false;
      }
      prevRightSelection = cardIndex;
      rightList[cardIndex].selected = true;
    });
    checkMatch();
  }

  void checkMatch() async {
    if (prevLeftSelection != null && prevRightSelection != null) {
      final leftCard = leftList[prevLeftSelection!];
      final rightCard = rightList[prevRightSelection!];
      final status = matchingCardBoard.checkMatch(leftCard, rightCard);
      final isMatch = status == MatchStatus.match;
      matchingCardBoard.setMatchPoints(isMatch);
      if (isMatch) {
        updateScore();
        matchingCardBoard.removeFromSelectedCards(
            leftList[prevLeftSelection!], rightList[prevRightSelection!]);
      }
      setState(() {
        leftList[prevLeftSelection!].status = status;
        rightList[prevRightSelection!].status = status;
      });
      resetBoard(prevLeftSelection, prevRightSelection, isMatch);
    }
  }

  Future<void> resetBoard(leftIndex, rightIndex, isMatch) async {
    final int duration =
        leftList[leftIndex].status == MatchStatus.match ? 500 : 300;
    setState(() {
      prevLeftSelection = null;
      prevRightSelection = null;
    });
    return Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        leftList[leftIndex].selected = false;
        rightList[rightIndex].selected = false;
        if (leftList[leftIndex].status == MatchStatus.noMatch) {
          leftList[leftIndex].status = MatchStatus.visible;
          rightList[rightIndex].status = MatchStatus.visible;
        } else {
          leftList[leftIndex].status = MatchStatus.hidden;
          rightList[rightIndex].status = MatchStatus.hidden;
        }
      });
      if (isMatch && matchingCardBoard.numberOfMatches % 4 == 0) {
        fillCards();
      }
    });
  }

  void updateScore() {
    setState(() {
      numberOfMatches = matchingCardBoard.numberOfMatches;
      score += matchingCardBoard.calculateScore();
    });
  }

  void onCountdownFinished() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 0),
        pageBuilder: (context, animation, secondaryAnimation) => FinalScore(
          score: score,
          totalMatches: numberOfMatches,
        ),
      ),
    );
  }

  Color getColor(selected) {
    return selected ? Theme.of(context).colorScheme.secondary : Colors.white;
  }

  bool isLeftCardVisisble(int cardIndex) {
    return matchingCardBoard.isCardVisible(leftList[cardIndex]) && gameStarted;
  }

  bool isRightCardVisible(int cardIndex) {
    return matchingCardBoard.isCardVisible(rightList[cardIndex]) && gameStarted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MatchAppBar(
              controller: _controller,
              score: score,
              onCountdownFinished: onCountdownFinished),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  key: const Key('leftGrid'),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: leftList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCard(
                      key: Key('leftCard-${leftList[index].id}'),
                      isMatch: leftList[index].status,
                      selected: leftList[index].selected == true,
                      text: widget.version == 'v1' ? leftList[index].name : '',
                      fitCover: leftList[index].isPlayer == false,
                      imageUrl: leftList[index].imageUrl,
                      isHeldDown: index == leftHeldDown,
                      disabled: leftList[index].status == MatchStatus.hidden ||
                          !gameStarted,
                      onTap: () {
                        leftHeldDown = null;
                        if (!isLeftCardVisisble(index)) {
                          return;
                        }
                        onLeftCardTap(index);
                      },
                      onTapDown: (_) {
                        if (!isLeftCardVisisble(index)) {
                          return;
                        }
                        setState(() {
                          leftHeldDown = index;
                        });
                      },
                      onTapCancel: () {
                        if (!isLeftCardVisisble(index)) {
                          return;
                        }
                        setState(() {
                          leftHeldDown = null;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: GridView.builder(
                  key: const Key('rightGrid'),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: rightList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCard(
                      key: Key('rightCard-${rightList[index].id}'),
                      isMatch: rightList[index].status,
                      selected: rightList[index].selected == true,
                      text: widget.version == 'v1' ? rightList[index].name : '',
                      imageUrl: rightList[index].imageUrl,
                      isHeldDown: rightHeldDown == index,
                      disabled: rightList[index].status == MatchStatus.hidden ||
                          !gameStarted,
                      onTap: () {
                        rightHeldDown = null;
                        if (!isRightCardVisible(index)) {
                          return;
                        }
                        onRightCardTap(index);
                      },
                      onTapDown: (_) {
                        if (!isRightCardVisible(index)) {
                          return;
                        }
                        setState(() {
                          rightHeldDown = index;
                        });
                      },
                      onTapCancel: () {
                        if (!isRightCardVisible(index)) {
                          return;
                        }
                        setState(() {
                          rightHeldDown = null;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Visibility(
            visible: !gameStarted,
            maintainState: true,
            child: Align(
              child: ElevatedButton(
                onPressed: startTimer,
                child: const Text('LET\'S GO!'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
