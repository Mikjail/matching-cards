import 'package:flutter/material.dart';
import 'package:of_card_match/matching_cards/matching_cards.dart';

class CustomCard extends StatelessWidget {
  final bool selected;
  final int cardIndex;
  final String text;
  final MatchStatus isMatch;
  final bool isHeldDown;
  final bool disabled;

  const CustomCard({
    Key? key,
    this.isHeldDown = false,
    this.isMatch = MatchStatus.reset,
    this.disabled = false,
    this.selected = false,
    required this.cardIndex,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      // There is a match!
      if (selected && isMatch == MatchStatus.match) {
        return const Color.fromARGB(255, 119, 206, 122);
      }
      // There is no match!
      if (selected && isMatch == MatchStatus.noMatch) {
        return Colors.red;
      }
      // The card is selected!
      if (selected || isHeldDown == true) {
        return const Color.fromARGB(255, 225, 250, 82);
      }
      // The card is disabled!
      if (disabled == true) {
        return Colors.transparent;
      }
      return const Color.fromARGB(243, 243, 244, 245);
    }

    Color textColor = Colors.white;

    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 100),
      decoration: BoxDecoration(
        border: Border.all(
          color: getColor(),
          width: selected || isHeldDown == true ? 4.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.all(5),
      child: TweenAnimationBuilder<Color?>(
          tween: ColorTween(
            begin: textColor,
            end: disabled ? textColor.withOpacity(0) : textColor,
          ),
          duration: const Duration(milliseconds: 400),
          builder: (_, Color? color, __) {
            return Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            );
          }),
    );
  }
}
