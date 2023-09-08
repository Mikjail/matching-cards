import 'package:flutter/material.dart';
import 'package:of_card_match/matching_cards/matching_cards.dart';

class CustomCard extends StatelessWidget {
  final bool selected;
  final int cardIndex;
  final Function(int) onCardTap;
  final String text;
  final MatchStatus isMatch;

  const CustomCard(
      {Key? key,
      this.isMatch = MatchStatus.reset,
      this.selected = false,
      required this.cardIndex,
      required this.onCardTap,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCardTap(cardIndex);
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected && isMatch == MatchStatus.match
                ? const Color.fromARGB(255, 119, 206, 122)
                : selected && isMatch == MatchStatus.noMatch
                    ? const Color.fromARGB(255, 231, 83, 72)
                    : selected
                        ? const Color.fromARGB(255, 225, 250, 82)
                        : const Color.fromARGB(243, 243, 244, 245),
            width: selected ? 4.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(5),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
