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
    return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
        margin: const EdgeInsets.all(5),
        color: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected
                ? const Color.fromARGB(255, 225, 250, 82)
                : const Color.fromARGB(243, 243, 244, 245),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: InkWell(
          onTap: () {
            onCardTap(cardIndex);
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
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
        ),
      ),
    );
  }
}
