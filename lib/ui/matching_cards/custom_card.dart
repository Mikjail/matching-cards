import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class CustomCard extends StatefulWidget {
  final bool selected;
  final String text;
  final String imageUrl;
  final MatchStatus status;
  final bool isHeldDown;
  final bool disabled;
  final bool fitCover;
  final bool isFirstRun;

  final void Function(FlipCardController) onTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function() onTapCancel;

  const CustomCard({
    Key? key,
    this.isHeldDown = false,
    this.status = MatchStatus.hidden,
    this.disabled = false,
    this.selected = false,
    this.imageUrl = '',
    this.text = '',
    this.fitCover = false,
    this.isFirstRun = true,
    required this.onTap,
    required this.onTapDown,
    required this.onTapCancel,
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  final controller = FlipCardController();

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

    onCardTap() {
      widget.onTap(controller);
    }

    Color textColor = CustomTheme.white;

    final borderDuration = widget.disabled ? 300 : 100;

    final opacityDuration = widget.status == MatchStatus.visible ? 1000 : 300;

    return GestureDetector(
      onTap: onCardTap,
      onTapDown: widget.onTapDown,
      onTapCancel: widget.onTapCancel,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: Duration(milliseconds: borderDuration),
        decoration: BoxDecoration(
          color: CustomTheme.darkGray,
          image: widget.text == ''
              ? const DecorationImage(
                  image: AssetImage('assets/imgs/card_back.png'),
                  fit: BoxFit.none,
                  scale: 4,
                )
              : null,
          border: Border.all(
            color: getColor(),
            width: widget.selected || widget.isHeldDown == true ? 3.0 : 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(5),
        child: TweenAnimationBuilder<double?>(
            tween: Tween<double>(
              begin: widget.isFirstRun ? 1 : 0,
              end: widget.disabled ? 0 : 1,
            ),
            duration: Duration(milliseconds: opacityDuration),
            builder: (_, double? opacity, __) {
              return Opacity(
                  opacity: opacity ?? 0,
                  child: buildCard(widget.text, widget.imageUrl, textColor,
                      widget.disabled, widget.fitCover, controller));
            }),
      ),
    );
  }
}

Widget buildCard(String text, String imageUrl, Color textColor, bool disabled,
    bool fitCover, controller) {
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

  return FlipCard(
    flipOnTouch: false,
    controller: controller,
    front: Stack(children: [
      buildImage(fitCover, imageUrl),
      Center(
          child: Image.asset("assets/imgs/vector.png", width: 64, height: 75)),
    ]),
    back: Center(
        child: Image.asset("assets/imgs/vector.png", width: 64, height: 75)),
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
