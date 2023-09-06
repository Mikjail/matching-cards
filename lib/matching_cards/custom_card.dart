import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final bool selected;
  final int cardIndex;
  final Function(int) onCardTap;
  final String text;

  const CustomCard(
      {Key? key,
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
            color: selected
                ? const Color.fromARGB(255, 225, 250, 82)
                : const Color.fromARGB(243, 243, 244, 245),
            width: selected ? 4.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(5),
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? const Color.fromARGB(255, 225, 250, 82)
                : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
