import 'package:flutter/material.dart';

class MatchingGrid extends StatefulWidget {
  const MatchingGrid({Key? key}) : super(key: key);

  @override
  State<MatchingGrid> createState() => MatchingGridState();
}

class MatchingGridState extends State<MatchingGrid> {
  Set<int> leftIndex = <int>{};
  Set<int> rightIndex = <int>{};

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
      if (rightIndex.contains(cardIndex)) {
        rightIndex.remove(cardIndex);
      } else {
        rightIndex.add(cardIndex);
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
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
            ),
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                margin: const EdgeInsets.all(5),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: leftIndex.contains(0)
                        ? const Color.fromARGB(255, 225, 250, 82)
                        : const Color.fromARGB(243, 243, 244, 245),
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => onCardTap(0),
                  child: Center(
                    child: Text(
                      "Left",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16, color: getColor(leftIndex.contains(0))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.5,
            ),
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                margin: const EdgeInsets.all(5),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: rightIndex.contains(0)
                        ? const Color.fromARGB(255, 225, 250, 82)
                        : const Color.fromARGB(243, 243, 244, 245),
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () => onRightCardTap(0),
                  child: Center(
                    child: Text(
                      "Right",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: getColor(rightIndex.contains(0))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
