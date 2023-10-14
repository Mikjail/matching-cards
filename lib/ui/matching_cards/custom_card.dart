import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class CustomCard extends StatelessWidget {
  final bool selected;
  final String text;
  final MatchStatus isMatch;
  final bool isHeldDown;
  final bool disabled;
  final void Function() onTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function() onTapCancel;

  const CustomCard({
    Key? key,
    this.isHeldDown = false,
    this.isMatch = MatchStatus.hidden,
    this.disabled = false,
    this.selected = false,
    required this.text,
    required this.onTap,
    required this.onTapDown,
    required this.onTapCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      // There is a match!
      if (selected && isMatch == MatchStatus.match) {
        return CustomTheme.success;
      }
      // There is no match!
      if (selected && isMatch == MatchStatus.noMatch) {
        return CustomTheme.error;
      }
      // The card is selected!
      if (selected || isHeldDown == true) {
        return CustomTheme.accent;
      }
      // The card is disabled!
      if (disabled == true) {
        return CustomTheme.grey;
      }
      return CustomTheme.white;
    }

    Color textColor = CustomTheme.white;

    final borderDuration = disabled ? 300 : 100;

    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: Duration(milliseconds: borderDuration),
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
              begin: textColor.withOpacity(0),
              end: disabled ? textColor.withOpacity(0) : textColor,
            ),
            duration: const Duration(milliseconds: 300),
            builder: (_, Color? color, __) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
