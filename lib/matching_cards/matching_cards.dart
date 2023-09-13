import 'package:flutter/material.dart';
import 'package:of_card_match/matching_cards/custom_card.dart';
import 'package:of_card_match/models/team.dart';
import 'package:of_card_match/services/matching_card_service.dart';
import '../locator.dart';

enum MatchStatus {
  match,
  noMatch,
  reset,
}

class MatchingGrid extends StatefulWidget {
  const MatchingGrid({Key? key}) : super(key: key);

  @override
  State<MatchingGrid> createState() => MatchingGridState();
}

class MatchingGridState extends State<MatchingGrid> {
  final matchingCardService = locator.get<MatchingCardService>();
  late MatchingCardBoard matchingCardBoard;
  int? prevLeftSelection;
  int? prevRightSelection;
  int? leftHeldDown;
  int? rightHeldDown;
  List<Map<String, dynamic>> leftList = [];
  List<Map<String, dynamic>> rightList = [];

  MatchStatus isMatch = MatchStatus.reset;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // we use the cardMatching service
    final cards = await matchingCardService.getMatchingCards();
    matchingCardBoard = MatchingCardBoard(cards: cards);
    fillCards();
  }

  void fillCards() {
    matchingCardBoard.pickRandomCards(4);
    setState(() {
      leftList = matchingCardBoard.getShuffledCardsFromKey('team');
      rightList = matchingCardBoard.getShuffledCardsFromKey('player');
    });
  }

  void onLeftCardTap(int cardIndex) {
    if (leftList[cardIndex]['status'] == MatchStatus.match) return;

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
    if (rightList[cardIndex]['status'] == MatchStatus.match) return;
    print(cardIndex);
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
      final match = matchingCardBoard.isMatch(left, right);
      setState(() {
        isMatch = match ? MatchStatus.match : MatchStatus.noMatch;
        leftList[prevLeftSelection!]['status'] = isMatch;
        rightList[prevRightSelection!]['status'] = isMatch;
      });
      if (match) {
        matchingCardBoard.numberOfMatches += 1;
        removeCardMatch();
        // timeout to allow the animation to finish
      }
      resetBoard(prevLeftSelection, prevRightSelection);
    }
  }

  void removeCardMatch() {
    setState(() {
      matchingCardBoard.removeFromSelectedCards(
          leftList[prevLeftSelection!]['name'],
          rightList[prevRightSelection!]['name']);
    });
  }

  Future<void> resetBoard(leftIndex, rightIndex) async {
    final int duration = isMatch == MatchStatus.match ? 500 : 300;
    setState(() {
      prevLeftSelection = null;
      prevRightSelection = null;
    });
    return Future.delayed(Duration(milliseconds: duration), () {
      setState(() {
        isMatch = MatchStatus.reset;
        leftList[leftIndex]['selected'] = false;
        rightList[rightIndex]['selected'] = false;
        if (leftList[leftIndex]['status'] == MatchStatus.noMatch) {
          leftList[leftIndex]['status'] = MatchStatus.reset;
          rightList[rightIndex]['status'] = MatchStatus.reset;
        }
      });
      if (matchingCardBoard.numberOfMatches == 4) {
        matchingCardBoard.numberOfMatches = 0;
        fillCards();
      }
    });
  }

  getColor(selected) {
    return selected ? const Color.fromARGB(255, 225, 250, 82) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              key: const Key('leftGrid'),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2,
              ),
              itemCount: leftList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    leftHeldDown = null;
                    onLeftCardTap(index);
                  },
                  onTapDown: (_) {
                    if (leftList[index]['status'] == MatchStatus.match) return;
                    setState(() {
                      leftHeldDown = index;
                    });
                  },
                  onTapCancel: () {
                    if (leftList[index]['status'] == MatchStatus.match) return;
                    setState(() {
                      leftHeldDown = null;
                    });
                  },
                  child: CustomCard(
                    key: Key('leftCard-$index'),
                    isMatch: leftList[index]['status'],
                    selected: leftList[index]['selected'] == true,
                    text: leftList[index]['name']!,
                    isHeldDown: index == leftHeldDown,
                    disabled: leftList[index]['status'] == MatchStatus.match,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              key: const Key('rightGrid'),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2,
              ),
              itemCount: rightList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    rightHeldDown = null;
                    onRightCardTap(index);
                  },
                  onTapDown: (_) {
                    if (rightList[index]['status'] == MatchStatus.match) return;
                    setState(() {
                      rightHeldDown = index;
                    });
                  },
                  onTapCancel: () {
                    if (rightList[index]['status'] == MatchStatus.match) return;
                    setState(() {
                      rightHeldDown = null;
                    });
                  },
                  child: CustomCard(
                    key: Key('rightCard-$index'),
                    isMatch: rightList[index]['status'],
                    selected: rightList[index]['selected'] == true,
                    text: rightList[index]['name']!,
                    isHeldDown: rightHeldDown == index,
                    disabled: rightList[index]['status'] == MatchStatus.match,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
