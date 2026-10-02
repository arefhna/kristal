import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../state/providers.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future<void>.delayed(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, Animation<double> anim, __, Widget child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemePalette palette = ref.watch(themePaletteProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.backgroundGradient,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildCrystalLogo(palette),
                  const SizedBox(height: 32),
                  Text(
                    'KRISTAL',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8.0,
                      shadows: <Shadow>[
                        Shadow(
                          color: palette.accent.withValues(alpha: 0.5),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BLOK TAPMACASI',
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 4.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCrystalLogo(ThemePalette palette) {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(
        painter: _CrystalLogoPainter(palette: palette),
      ),
    );
  }
}

class _CrystalLogoPainter extends CustomPainter {
  _CrystalLogoPainter({required this.palette});

  final ThemePalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width;
    final List<Offset> points = <Offset>[
      Offset(s * 0.5, 0),
      Offset(s, s * 0.5),
      Offset(s * 0.5, s),
      Offset(0, s * 0.5),
    ];

    final Path path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    final Paint fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          palette.accent,
          palette.blockColors.first,
          palette.blockColors[2 % palette.blockColors.length],
        ],
      ).createShader(Offset.zero & size);

    final Paint glow = Paint()
      ..color = palette.accent.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);

    canvas.drawPath(path, glow);
    canvas.drawPath(path, fill);

    final Paint border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.55);
    canvas.drawPath(path, border);

    final Path inner = Path()
      ..moveTo(s * 0.5, s * 0.15)
      ..lineTo(s * 0.5, s * 0.85);
    final Paint innerLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withValues(alpha: 0.35);
    canvas.drawPath(inner, innerLine);
  }

  @override
  bool shouldRepaint(covariant _CrystalLogoPainter old) =>
      old.palette != palette;
}
