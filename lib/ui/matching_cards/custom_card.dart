import 'package:flutter/material.dart';
import 'package:of_card_match/theme/colors.dart';
import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class CustomCard extends StatelessWidget {
  final bool selected;
  final String text;
  final String imageUrl;
  final MatchStatus isMatch;
  final bool isHeldDown;
  final bool disabled;
  final bool fitCover;
  final void Function() onTap;
  final void Function(TapDownDetails) onTapDown;
  final void Function() onTapCancel;

  const CustomCard({
    Key? key,
    this.isHeldDown = false,
    this.isMatch = MatchStatus.hidden,
    this.disabled = false,
    this.selected = false,
    this.imageUrl = '',
    this.text = '',
    this.fitCover = false,
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
      return CustomTheme.white.withOpacity(0.0);
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
          color: CustomTheme.darkGray,
          image: text == ''
              ? const DecorationImage(
                  image: AssetImage('assets/imgs/card_back.png'),
                  fit: BoxFit.none,
                  scale: 4,
                )
              : null,
          border: Border.all(
            color: getColor(),
            width: selected || isHeldDown == true ? 3.0 : 0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(5),
        child: TweenAnimationBuilder<double?>(
            tween: Tween<double>(
              begin: 1,
              end: disabled ? 0 : 1,
            ),
            duration: const Duration(milliseconds: 300),
            builder: (_, double? opacity, __) {
              return Opacity(
                  opacity: opacity ?? 0,
                  child:
                      buildCard(text, imageUrl, textColor, disabled, fitCover));
            }),
      ),
    );
  }
}

Widget buildCard(String text, String imageUrl, Color textColor, bool disabled,
    bool fitCover) {
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

  return Stack(children: [
    buildImage(fitCover, imageUrl),
    Center(child: Image.asset("assets/imgs/vector.png", width: 64, height: 75)),
  ]);
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
