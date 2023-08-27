import 'dart:collection';

import 'package:flutter/material.dart';

class MatchingGrid extends StatefulWidget {
  const MatchingGrid({Key? key}) : super(key: key);

  @override
  State<MatchingGrid> createState() => _MatchingGridState();
}

class _MatchingGridState extends State<MatchingGrid> {
  var leftIndex = <int>{};
  var righttIndex = Set();

  void onCardTap(int cardIndex) {
    setState(() {
      if (leftIndex.contains(cardIndex)) {
        leftIndex.remove(cardIndex);
      } else {
        leftIndex.add(cardIndex);
      }
    });
  }

  void onRightCardTap(int cardIndex) {
    setState(() {
      if (leftIndex.contains(cardIndex)) {
        leftIndex.remove(cardIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
      ),
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          margin: const EdgeInsets.all(10),
          color: leftIndex.contains(0)
              ? Color.fromARGB(95, 255, 255, 255)
              : Colors.black,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color.fromRGBO(225, 250, 82, 100),
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: () => onCardTap(0),
            child: const Center(
              child: Text(
                "Left",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
