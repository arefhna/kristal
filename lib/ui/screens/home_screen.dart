import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/adventure_progress.dart';
import '../../data/models/daily_record.dart';
import '../../data/models/player_stats.dart';
import '../../game/adventure/adventure_catalog.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';
import '../widgets/menu_button.dart';
import 'adventure_screen.dart';
import 'daily_screen.dart';
import 'game_screen.dart';
import 'settings_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final PlayerStats stats = ref.watch(
      statsControllerProvider.select((s) => s.stats),
    );
    final DailyProgress daily = ref.watch(
      dailyControllerProvider.select((s) => s.progress),
    );
    final AdventureProgress adventure = ref.watch(
      adventureControllerProvider.select((s) => s.progress),
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
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 28),
                    Text(
                      'KRISTAL',
                      textAlign: TextAlign.center,
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
                    const SizedBox(height: 6),
                    Text(
                      'BLOK TAPMACASI',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _BestScoreCard(stats: stats, palette: palette),
                    const SizedBox(height: 22),
                    MenuButton(
                      label: 'OYNA',
                      subtitle: 'Klassik rejim',
                      icon: Icons.play_arrow_rounded,
                      palette: palette,
                      isPrimary: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const GameScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      label: 'GÜNDƏLİK ÇAĞIRIŞ',
                      subtitle: daily.hasPlayedToday
                          ? 'Bugün: ${daily.todayBestScore}  •  ${daily.currentStreak} gün seriya'
                          : 'Hər kəs üçün eyni lövhə',
                      icon: Icons.calendar_today_rounded,
                      palette: palette,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const DailyScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      label: 'MACƏRA',
                      subtitle:
                          '${adventure.completedLevelIds.length} / ${AdventureCatalog.levelCount} səviyyə  •  ${adventure.totalStars} ulduz',
                      icon: Icons.auto_awesome_rounded,
                      palette: palette,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const AdventureScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      label: 'STATİSTİKA',
                      icon: Icons.bar_chart_rounded,
                      palette: palette,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const StatsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    MenuButton(
                      label: 'AYARLAR',
                      icon: Icons.settings_rounded,
                      palette: palette,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'v0.1.0',
                        style: TextStyle(
                          color: palette.textSecondary.withValues(alpha: 0.6),
                          fontSize: 11,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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

class _BestScoreCard extends StatelessWidget {
  const _BestScoreCard({required this.stats, required this.palette});

  final PlayerStats stats;
  final ThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'ƏN YÜKSƏK XAL',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 11,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${stats.bestScore}',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 52,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              shadows: <Shadow>[
                Shadow(
                  color: palette.accent.withValues(alpha: 0.35),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _MiniStat(
                label: 'OYUN',
                value: '${stats.totalGames}',
                palette: palette,
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _MiniStat(
                label: 'XƏTT',
                value: '${stats.totalLines}',
                palette: palette,
              ),
              Container(
                width: 1,
                height: 28,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _MiniStat(
                label: 'COMBO',
                value: '${stats.longestCombo}',
                palette: palette,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.palette,
  });

  final String label;
  final String value;
  final ThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(
            color: palette.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: palette.textSecondary,
            fontSize: 10,
            letterSpacing: 2.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
