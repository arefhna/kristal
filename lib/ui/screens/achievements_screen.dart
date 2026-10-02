import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/achievement.dart';
import '../../data/models/achievement_progress.dart';
import '../../game/achievements/achievement_catalog.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() =>
      _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  AchievementCategory? _filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(achievementControllerProvider.notifier).markAllSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final AchievementProgress progress = ref.watch(
      achievementControllerProvider.select((s) => s.progress),
    );

    final List<Achievement> list = _filter == null
        ? AchievementCatalog.all
        : AchievementCatalog.all
            .where((a) => a.category == _filter)
            .toList(growable: false);

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
              Column(
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
                          'NAİLİYYƏTLƏR',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _ProgressHeader(
                    palette: palette,
                    unlocked: progress.unlockedCount,
                    total: AchievementCatalog.total,
                  ),
                  const SizedBox(height: 12),
                  _FilterBar(
                    palette: palette,
                    selected: _filter,
                    onSelect: (f) => setState(() => _filter = f),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final a = list[index];
                        final bool unlocked = progress.isUnlocked(a.id);
                        return _AchievementTile(
                          palette: palette,
                          achievement: a,
                          unlocked: unlocked,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.palette,
    required this.unlocked,
    required this.total,
  });

  final ThemePalette palette;
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double ratio = total == 0 ? 0 : unlocked / total;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'İRƏLİLƏYİŞ',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 11,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$unlocked / $total',
                  style: TextStyle(
                    color: palette.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(palette.accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.palette,
    required this.selected,
    required this.onSelect,
  });

  final ThemePalette palette;
  final AchievementCategory? selected;
  final ValueChanged<AchievementCategory?> onSelect;

  static const Map<AchievementCategory?, String> labels =
      <AchievementCategory?, String>{
    null: 'HAMISI',
    AchievementCategory.gameplay: 'OYUN',
    AchievementCategory.score: 'XAL',
    AchievementCategory.daily: 'GÜNDƏLİK',
    AchievementCategory.adventure: 'MACƏRA',
    AchievementCategory.special: 'XÜSUSİ',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: labels.entries.map((e) {
          final bool active = e.key == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelect(e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: active
                      ? palette.accent.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active
                        ? palette.accent
                        : Colors.white.withValues(alpha: 0.08),
                    width: active ? 1.5 : 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    e.value,
                    style: TextStyle(
                      color: active
                          ? palette.textPrimary
                          : palette.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.palette,
    required this.achievement,
    required this.unlocked,
  });

  final ThemePalette palette;
  final Achievement achievement;
  final bool unlocked;

  IconData _iconFor(String name) {
    switch (name) {
      case 'star':
        return Icons.star_rounded;
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'grid':
        return Icons.grid_view_rounded;
      case 'games':
        return Icons.sports_esports_rounded;
      case 'calendar':
        return Icons.calendar_today_rounded;
      case 'map':
        return Icons.map_rounded;
      case 'crown':
        return Icons.workspace_premium_rounded;
      case 'sparkle':
        return Icons.auto_awesome_rounded;
      case 'play':
      default:
        return Icons.play_arrow_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: unlocked
            ? palette.accent.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? palette.accent.withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.06),
          width: 1.0,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: unlocked
                  ? palette.accent.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              unlocked ? _iconFor(achievement.iconName) : Icons.lock_rounded,
              color: unlocked
                  ? palette.accent
                  : palette.textSecondary.withValues(alpha: 0.5),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: unlocked
                        ? palette.textPrimary
                        : palette.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: palette.textSecondary.withValues(
                      alpha: unlocked ? 1.0 : 0.6,
                    ),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (unlocked)
            Icon(
              Icons.check_circle_rounded,
              color: palette.accent,
              size: 22,
            ),
        ],
      ),
    );
  }
}
