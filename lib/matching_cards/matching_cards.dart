import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:of_card_match/matching_cards/custom_card.dart';
import 'package:of_card_match/services/matching_card_service.dart';

class MatchingGrid extends StatefulWidget {
  const MatchingGrid({Key? key}) : super(key: key);

  @override
  State<MatchingGrid> createState() => MatchingGridState();
}

class MatchingGridState extends State<MatchingGrid> {
  final matchingCardService = GetIt.instance.get<MatchingCardService>();
  int? leftIndexSelected;
  int? rightIndexSelected;
  List<String> leftList = [];
  List<String> rightList = [];
  List<dynamic> cards = [];
  List<dynamic> playingCards = [];

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

    playingCards = cards.take(5).toList();

    setState(() {
      leftList = playingCards.map((e) => e.keys.first.toString()).toList();
      rightList = playingCards.map((e) => e.values.first.toString()).toList();

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

  void checkMatch() {
    if (leftIndexSelected != null && rightIndexSelected != null) {
      final left = leftList[leftIndexSelected!];
      final right = rightList[rightIndexSelected!];
      // check if the left and right match one of the cards
      final match = playingCards.any((element) {
        return element[left] == right;
      });
      if (match) {
        print('Match!');
      } else {
        print('No Match!');
      }
    }
  }

  getColor(selected) {
    return selected ? const Color.fromARGB(255, 225, 250, 82) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 600,
            width: 200,
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
                  cardIndex: index,
                  selected: index == leftIndexSelected,
                  onCardTap: onLeftCardTap,
                  text: leftList[index],
                );
              },
            ),
          ),
          SizedBox(
            height: 600,
            width: 200,
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
                  text: rightList[index],
                  key: Key('rightCard-$index'),
                  cardIndex: index,
                  selected: index == rightIndexSelected,
                  onCardTap: onRightCardTap,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
