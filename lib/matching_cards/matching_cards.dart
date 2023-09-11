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
  int? leftIndexSelected;
  int? rightIndexSelected;
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
      leftIndexSelected = cardIndex;
    });
    checkMatch();
  }

  void onRightCardTap(int cardIndex) {
    if (rightList[cardIndex]['status'] == MatchStatus.match) return;
    setState(() {
      rightIndexSelected = cardIndex;
    });
    checkMatch();
  }

  void checkMatch() async {
    if (leftIndexSelected != null && rightIndexSelected != null) {
      final left = leftList[leftIndexSelected!]['name'];
      final right = rightList[rightIndexSelected!]['name'];
      final match = matchingCardBoard.isMatch(left, right);
      setState(() {
        isMatch = match ? MatchStatus.match : MatchStatus.noMatch;
        leftList[leftIndexSelected!]['status'] = isMatch;
        rightList[rightIndexSelected!]['status'] = isMatch;
      });
      if (match) {
        matchingCardBoard.numberOfMatches += 1;
        removeCardMatch();
        // timeout to allow the animation to finish
      }
      resetBoard();
    }
  }

  void removeCardMatch() {
    setState(() {
      matchingCardBoard.removeFromSelectedCards(
          leftList[leftIndexSelected!]['name'],
          rightList[rightIndexSelected!]['name']);
    });
  }

  Future<void> resetBoard() {
    return Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        leftIndexSelected = null;
        rightIndexSelected = null;
        isMatch = MatchStatus.reset;
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
                    isMatch: isMatch,
                    cardIndex: index,
                    selected: index == leftIndexSelected,
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
                    isMatch: isMatch,
                    cardIndex: index,
                    selected: index == rightIndexSelected,
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
