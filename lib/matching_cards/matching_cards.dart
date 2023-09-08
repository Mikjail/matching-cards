import 'package:flutter/material.dart';
import 'package:of_card_match/matching_cards/custom_card.dart';
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
  int? leftIndexSelected;
  int? rightIndexSelected;
  List<String> leftList = [];
  List<String> rightList = [];
  List<dynamic> cards = [];
  List<dynamic> playingCards = [];
  MatchStatus isMatch = MatchStatus.reset;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // we use the cardMatching service
    cards = await matchingCardService.getMatchingCards();

    // pop the first 5 elements from the list
    cards.shuffle();

    playingCards = cards.take(4).toList();

    setState(() {
      leftList = playingCards.map((e) => e['team'].toString()).toList();
      rightList = playingCards.map((e) => e['player'].toString()).toList();

      leftList.shuffle();
      rightList.shuffle();
    });
  }

  void onLeftCardTap(int cardIndex) {
    setState(() {
      if (leftIndexSelected == cardIndex) {
        leftIndexSelected = null;
      } else {
        leftIndexSelected = cardIndex;
        checkMatch();
      }
    });
  }

  void onRightCardTap(int cardIndex) {
    setState(() {
      if (rightIndexSelected == cardIndex) {
        rightIndexSelected = null;
      } else {
        rightIndexSelected = cardIndex;
        checkMatch();
      }
    });
  }

  void resetBoard() {
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        leftIndexSelected = null;
        rightIndexSelected = null;
        isMatch = MatchStatus.reset;
      });
    });
  }

  void checkMatch() {
    if (leftIndexSelected != null && rightIndexSelected != null) {
      final left = leftList[leftIndexSelected!];
      final right = rightList[rightIndexSelected!];
      final match = playingCards.firstWhere(
        (element) => element['team'] == left && element['player'] == right,
        orElse: () => null,
      );
      print(match);
      if (match != null) {
        setState(() {
          isMatch = MatchStatus.match;
        });
        resetBoard();
      } else {
        setState(() {
          isMatch = MatchStatus.noMatch;
        });
        resetBoard();
      }
    }
  }

  getColor(selected) {
    return selected ? const Color.fromARGB(255, 225, 250, 82) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
              return CustomCard(
                key: Key('leftCard-$index'),
                isMatch: isMatch,
                cardIndex: index,
                selected: index == leftIndexSelected,
                onCardTap: onLeftCardTap,
                text: leftList[index],
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
              return CustomCard(
                key: Key('rightCard-$index'),
                isMatch: isMatch,
                cardIndex: index,
                selected: index == rightIndexSelected,
                onCardTap: onRightCardTap,
                text: rightList[index],
              );
            },
          ),
        )
      ],
    );
  }
}
