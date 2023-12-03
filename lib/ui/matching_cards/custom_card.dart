import 'dart:math';

import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

import 'flip_card.dart';

class CustomCard extends StatefulWidget {
  final String testKey;
  final bool selected;
  final String text;
  final String imageUrl;
  final MatchStatus status;
  final bool isHeldDown;
  final bool disabled;
  final bool fitCover;
  final bool isFirstRun;

  final void Function() onTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function() onTapCancel;

  const CustomCard({
    Key? key,
    this.isHeldDown = false,
    this.disabled = false,
    this.selected = false,
    this.imageUrl = '',
    this.text = '',
    this.fitCover = false,
    this.isFirstRun = true,
    required this.testKey,
    required this.status,
    required this.onTap,
    required this.onTapDown,
    required this.onTapCancel,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<MatchStatus> _status;

  @override
  void initState() {
    super.initState();
    _status = ValueNotifier<MatchStatus>(widget.status);
  }

  @override
  void didUpdateWidget(CustomCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status) {
      _status.value = widget.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      // There is a match!
      if (widget.selected && widget.status == MatchStatus.match) {
        return CustomTheme.success;
      }
      // There is no match!
      if (widget.selected && widget.status == MatchStatus.noMatch) {
        return CustomTheme.error;
      }
      // The card is selected!
      if (widget.selected || widget.isHeldDown == true) {
        return CustomTheme.accent;
      }
      // The card is disabled!
      if (widget.disabled == true) {
        return CustomTheme.grey;
      }
      return CustomTheme.white.withOpacity(0.0);
    }

    Color textColor = CustomTheme.white;

    final borderDuration = widget.disabled ? 300 : 100;

    void onTap() {
      widget.onTap();
    }

    return GestureDetector(
      onTap: onTap,
      onTapDown: widget.onTapDown,
      onTapCancel: widget.onTapCancel,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: Duration(milliseconds: borderDuration),
        decoration: BoxDecoration(
          color: CustomTheme.darkGray,
          image: null,
          border: Border.all(
            color: getColor(),
            width: widget.selected || widget.isHeldDown == true ? 3.0 : 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(5),
        child: widget.text != ''
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              )
            : FlipCard(
                front: Stack(children: [
                  buildImage(widget.fitCover, widget.imageUrl),
                  Center(
                      child: Image.asset("assets/imgs/vector.png",
                          width: 64, height: 75)),
                ]),
                back: Center(
                    child: Image.asset("assets/imgs/card_back.png",
                        width: 64, height: 75)),
                status: _status,
              ),
      ),
    );
  }
}

Widget buildCard(String text, String imageUrl, Color textColor, bool fitCover,
    AnimationController controller, ValueNotifier<MatchStatus> status) {
  if (text != '') {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    );
  }
  return Transform(
    alignment: Alignment.center,
    transform: Matrix4.identity()
      ..setEntry(3, 2, 0.001) // perspective
      ..rotateY(pi * controller.value), // Flip
    child: GestureDetector(
      child: controller.value < 0.5
          ? Center(
              child: Image.asset("assets/imgs/card_back.png",
                  width: 64, height: 75))
          : Stack(children: [
              buildImage(fitCover, imageUrl),
              Center(
                  child: Image.asset("assets/imgs/vector.png",
                      width: 64, height: 75)),
            ]),
    ),
  );
}

Widget buildImage(bool fitCover, String imageUrl) {
  if (fitCover == false) {
    return Center(
      child: ClipPath(
        clipper: TriangleClipper(),
        child: Image.network(
          imageUrl,
          width: 89,
          height: 70,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
    );
  }
  return Center(
    child: CustomPaint(
      painter: TrianglePainter(),
      child: Image.network(
        imageUrl,
        width: 55,
        height: 70,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      ),
    ),
  );
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.1729000, size.height * 0.0066000);

    path.lineTo(size.width * 0.1834000, size.height * 0.8458000);

    path.lineTo(size.width * 0.4965000, size.height * 1.0010000);
    // bottom right
    path.lineTo(size.width * 0.7976000, size.height * 0.8594000);
    path.lineTo(size.width * 0.8140000, size.height * 0.0039000);
    path.lineTo(size.width * 0.1729000, size.height * 0.0066000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(-1, -1);
    path.lineTo(-1, size.height * 0.8558000);
    path.lineTo(size.width * 0.5965000, size.height * 1.0010000);
    path.lineTo(size.width, size.height * 0.8694000);
    path.lineTo(size.width + 1, size.height * 0.0059000);
    path.lineTo(size.width * 0.1729000, size.height * 0.0066000);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => false;
}
