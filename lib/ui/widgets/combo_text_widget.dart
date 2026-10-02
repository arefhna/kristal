import 'package:flutter/material.dart';

class ComboTextWidget extends StatelessWidget {
  const ComboTextWidget({
    super.key,
    required this.text,
    required this.color,
    required this.opacity,
    required this.scale,
  });

  final String text;
  final Color color;
  final double opacity;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: scale.clamp(0.0, 2.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: color.withValues(alpha: 0.45),
                shadows: <Shadow>[
                  Shadow(
                    color: color.withValues(alpha: 0.6),
                    blurRadius: 24,
                  ),
                ],
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
