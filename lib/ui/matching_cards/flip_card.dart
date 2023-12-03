import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final ValueNotifier<MatchStatus> status;

  const FlipCard({
    Key? key,
    required this.front,
    required this.back,
    required this.status,
  }) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MatchStatus>(
        valueListenable: widget.status,
        builder: (context, value, child) {
          if (value == MatchStatus.visible) {
            _controller.reverse();
          } else if (value == MatchStatus.hidden) {
            _controller.forward();
          }
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(math.pi * _animation.value), // Flip
                child: _animation.value < 0.5 ? widget.front : widget.back,
              );
            },
          );
        });
  }
}
