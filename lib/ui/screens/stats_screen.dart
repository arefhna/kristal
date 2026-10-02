import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/player_stats.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final PlayerStats stats = ref.watch(
      statsControllerProvider.select((s) => s.stats),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: palette.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(
                  painter: BackgroundPainter(palette: palette),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: palette.textPrimary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'STATİSTİKA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _StatCard(
                      palette: palette,
                      label: 'Ən yüksək xal',
                      value: '${stats.bestScore}',
                      icon: Icons.emoji_events_rounded,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      palette: palette,
                      label: 'Ümumi oyun',
                      value: '${stats.totalGames}',
                      icon: Icons.sports_esports_rounded,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      palette: palette,
                      label: 'Silinən xətt',
                      value: '${stats.totalLines}',
                      icon: Icons.grid_off_rounded,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      palette: palette,
                      label: 'Ən uzun combo',
                      value: '${stats.longestCombo}',
                      icon: Icons.local_fire_department_rounded,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      palette: palette,
                      label: 'Ümumi xal',
                      value: '${stats.totalScore}',
                      icon: Icons.stacked_line_chart_rounded,
                    ),
                    const SizedBox(height: 12),
                    _StatCard(
                      palette: palette,
                      label: 'Orta xal',
                      value: stats.averageScore.toStringAsFixed(0),
                      icon: Icons.trending_up_rounded,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.palette,
    required this.label,
    required this.value,
    required this.icon,
  });

  final ThemePalette palette;
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: palette.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: palette.accent, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.8,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
