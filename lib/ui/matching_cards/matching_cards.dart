import 'package:flutter/foundation.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:of_card_match/ui/matching_cards/custom_card.dart';
import 'package:of_card_match/models/team.dart';
import 'package:of_card_match/services/matching_card_service.dart';
import 'package:of_card_match/ui/matching_cards/match_app_bar.dart';
import 'package:of_card_match/ui/start._screen.dart';
import '../../locator.dart';

enum MatchStatus {
  match,
  noMatch,
  reset,
}

class MatchingCards extends StatefulWidget {
  const MatchingCards({Key? key}) : super(key: key);

  @override
  State<MatchingCards> createState() => MatchingCardsState();
}

class MatchingCardsState extends State<MatchingCards> {
  final matchingCardService = locator.get<MatchingCardService>();
  final _controller = CountDownController();
  late MatchingCardBoard matchingCardBoard;
  bool gameStarted = false;
  int numberOfMatches = 0;
  int? prevLeftSelection;
  int? prevRightSelection;
  int? leftHeldDown;
  int? rightHeldDown;
  List<Map<String, dynamic>> leftList = [];
  List<Map<String, dynamic>> rightList = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    // we use the cardMatching service
    final cards = await matchingCardService.getMatchingCards();
    matchingCardBoard = MatchingCardBoard(cards: cards);
    fillCards();
  }

  void startTimer() {
    _controller.start();
    setState(() {
      gameStarted = true;
    });
  }

  void fillCards() {
    matchingCardBoard.pickRandomCards(4);
    setState(() {
      leftList = matchingCardBoard.getShuffledCardsFromKey('team');
      rightList = matchingCardBoard.getShuffledCardsFromKey('player');
    });
  }

  void onLeftCardTap(int cardIndex) {
    if (leftList[cardIndex]['status'] == MatchStatus.match || !gameStarted)
      return;

    setState(() {
      if (prevLeftSelection != null) {
        leftList[prevLeftSelection!]['selected'] = false;
      }
      prevLeftSelection = cardIndex;
      leftList[cardIndex]['selected'] = true;
    });
    checkMatch();
  }

  void onRightCardTap(int cardIndex) {
    if (rightList[cardIndex]['status'] == MatchStatus.match || !gameStarted)
      return;

    setState(() {
      if (prevRightSelection != null) {
        rightList[prevRightSelection!]['selected'] = false;
      }
      prevRightSelection = cardIndex;
      rightList[cardIndex]['selected'] = true;
    });
    checkMatch();
  }

  void checkMatch() async {
    if (prevLeftSelection != null && prevRightSelection != null) {
      final left = leftList[prevLeftSelection!]['name'];
      final right = rightList[prevRightSelection!]['name'];
      final status = matchingCardBoard.getStatus(left, right);
      final isMatch = status == MatchStatus.match;
      setState(() {
        leftList[prevLeftSelection!]['status'] = status;
        rightList[prevRightSelection!]['status'] = status;
        if (isMatch) numberOfMatches += 1;
      });
      if (isMatch) {
        removeCardMatch();
        // timeout to allow the animation to finish
      }
      resetBoard(prevLeftSelection, prevRightSelection, isMatch);
    }
  }

  void removeCardMatch() {
    setState(() {
      matchingCardBoard.removeFromSelectedCards(
          leftList[prevLeftSelection!]['name'],
          rightList[prevRightSelection!]['name']);
    });
  }

  Future<void> resetBoard(leftIndex, rightIndex, isMatch) async {
    final int duration =
        leftList[leftIndex]['status'] == MatchStatus.match ? 500 : 300;
    setState(() {
      prevLeftSelection = null;
      prevRightSelection = null;
    });
    return Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        leftList[leftIndex]['selected'] = false;
        rightList[rightIndex]['selected'] = false;
        if (leftList[leftIndex]['status'] == MatchStatus.noMatch) {
          leftList[leftIndex]['status'] = MatchStatus.reset;
          rightList[rightIndex]['status'] = MatchStatus.reset;
        }
      });
      if (isMatch && numberOfMatches % 4 == 0) {
        fillCards();
      }
    });
  }

  void onCountdownFinished() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartScreen(), //add result screen
      ),
    );
  }

  getColor(selected) {
    return selected ? const Color.fromARGB(255, 225, 250, 82) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          MatchAppBar(
              controller: _controller,
              numberOfMatches: numberOfMatches,
              onCountdownFinished: onCountdownFinished),
          const SizedBox(height: 30),
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
                    childAspectRatio: 2,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: leftList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCard(
                      key: Key('leftCard-$index'),
                      isMatch: leftList[index]['status'],
                      selected: leftList[index]['selected'] == true,
                      text: leftList[index]['name']!,
                      isHeldDown: index == leftHeldDown,
                      disabled: !gameStarted ||
                          leftList[index]['status'] == MatchStatus.match,
                      onTap: () {
                        leftHeldDown = null;
                        onLeftCardTap(index);
                      },
                      onTapDown: (_) {
                        if (leftList[index]['status'] == MatchStatus.match ||
                            !gameStarted) {
                          return;
                        }
                        setState(() {
                          leftHeldDown = index;
                        });
                      },
                      onTapCancel: () {
                        if (leftList[index]['status'] == MatchStatus.match ||
                            !gameStarted) {
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
              Expanded(
                child: GridView.builder(
                  key: const Key('rightGrid'),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: rightList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return CustomCard(
                      key: Key('rightCard-$index'),
                      isMatch: rightList[index]['status'],
                      selected: rightList[index]['selected'] == true,
                      text: rightList[index]['name']!,
                      isHeldDown: rightHeldDown == index,
                      disabled: !gameStarted ||
                          rightList[index]['status'] == MatchStatus.match,
                      onTap: () {
                        rightHeldDown = null;
                        onRightCardTap(index);
                      },
                      onTapDown: (_) {
                        if (rightList[index]['status'] == MatchStatus.match ||
                            !gameStarted) {
                          return;
                        }
                        setState(() {
                          rightHeldDown = index;
                        });
                      },
                      onTapCancel: () {
                        if (rightList[index]['status'] == MatchStatus.match ||
                            !gameStarted) {
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
          const SizedBox(height: 30),
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
