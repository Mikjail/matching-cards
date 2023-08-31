import 'package:flutter/material.dart';
import 'package:of_card_match/matching_cards/custom_card.dart';

class MatchingGrid extends StatefulWidget {
  const MatchingGrid({Key? key}) : super(key: key);

  @override
  State<MatchingGrid> createState() => MatchingGridState();
}

class MatchingGridState extends State<MatchingGrid> {
  int? leftIndexSelected;
  int? rightIndexSelected;
  final List<int> mockDataLeft = List.generate(4, (index) => index);
  final List<int> mockDataRight = List.generate(4, (index) => index);

  void onLeftCardTap(int cardIndex) {
    setState(() {
      if (leftIndexSelected == cardIndex) {
        leftIndexSelected = null;
      } else {
        leftIndexSelected = cardIndex;
      }
    });
  }

  void onRightCardTap(int cardIndex) {
    setState(() {
      if (rightIndexSelected == cardIndex) {
        rightIndexSelected = null;
      } else {
        rightIndexSelected = cardIndex;
      }
    });
  }

  getColor(selected) {
    return selected ? const Color.fromARGB(255, 225, 250, 82) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GridView.builder(
            key: const Key('leftGrid'),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 2,
            ),
            itemCount: mockDataLeft.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return CustomCard(
                key: Key('leftCard-$index'),
                cardIndex: index,
                selected: mockDataLeft[index] == leftIndexSelected,
                onCardTap: onLeftCardTap,
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
            itemCount: mockDataRight.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return CustomCard(
                key: Key('rightCard-$index'),
                cardIndex: index,
                selected: mockDataRight[index] == rightIndexSelected,
                onCardTap: onRightCardTap,
              );
            },
          ),
        )
      ],
    );
  }
}
