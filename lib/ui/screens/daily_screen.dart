import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/daily_record.dart';
import '../../game/daily_seed.dart';
import '../../state/game/game_controller.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';
import 'game_screen.dart';

class DailyScreen extends ConsumerWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final DailyProgress progress = ref.watch(
      dailyControllerProvider.select((s) => s.progress),
    );
    final String todayKey = ref.watch(
      dailyControllerProvider.select((s) => s.todayDateKey),
    );
    final int todaySeed = ref.watch(
      dailyControllerProvider.select((s) => s.todaySeed),
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
                            'GÜNDƏLİK',
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
                    _DateCard(
                      palette: palette,
                      dateKey: todayKey,
                    ),
                    const SizedBox(height: 20),
                    _StreakCard(
                      palette: palette,
                      streak: progress.currentStreak,
                      totalDays: progress.totalDaysPlayed,
                    ),
                    const SizedBox(height: 20),
                    _BestTodayCard(
                      palette: palette,
                      score: progress.todayBestScore,
                      hasPlayed: progress.hasPlayedToday,
                    ),
                    const Spacer(),
                    _PlayButton(
                      palette: palette,
                      label: progress.hasPlayedToday
                          ? 'YENİDƏN OYNA'
                          : 'OYNA',
                      onTap: () {
                        ref
                            .read(gameControllerProvider.notifier)
                            .startDaily(todaySeed);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GameScreen(
                              mode: GameMode.daily,
                            ),
                          ),
                        );
                      },
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

class _DateCard extends StatelessWidget {
  const _DateCard({required this.palette, required this.dateKey});

  final ThemePalette palette;
  final String dateKey;

  @override
  Widget build(BuildContext context) {
    final String display = DailySeed.formatDisplay(dateKey);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'BUGÜNKÜ ÇAĞIRIŞ',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 11,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            display,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Hər kəs üçün eyni lövhə',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({
    required this.palette,
    required this.streak,
    required this.totalDays,
  });

  final ThemePalette palette;
  final int streak;
  final int totalDays;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: palette.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: palette.accent,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'SERİYA',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 10,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  streak == 0 ? 'Başla!' : '$streak gün',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'ÜMUMİ',
                style: TextStyle(
                  color: palette.textSecondary,
                  fontSize: 10,
                  letterSpacing: 2.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$totalDays gün',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestTodayCard extends StatelessWidget {
  const _BestTodayCard({
    required this.palette,
    required this.score,
    required this.hasPlayed,
  });

  final ThemePalette palette;
  final int score;
  final bool hasPlayed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'BUGÜNKÜ REKORD',
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 11,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 44,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              shadows: <Shadow>[
                Shadow(
                  color: palette.accent.withValues(alpha: 0.35),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          if (!hasPlayed) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              'Hələ oynamamısan',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.palette,
    required this.label,
    required this.onTap,
  });

  final ThemePalette palette;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: palette.accent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: palette.accent.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.play_arrow_rounded,
                color: palette.backgroundGradient.first,
                size: 26,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: palette.backgroundGradient.first,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
