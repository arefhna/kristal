import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/adventure_level.dart';
import '../../data/models/adventure_progress.dart';
import '../../game/adventure/adventure_catalog.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';
import 'adventure_game_screen.dart';

class AdventureScreen extends ConsumerStatefulWidget {
  const AdventureScreen({super.key});

  @override
  ConsumerState<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends ConsumerState<AdventureScreen> {
  int _selectedWorld = 1;

  @override
  Widget build(BuildContext context) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final AdventureProgress progress = ref.watch(
      adventureControllerProvider.select((s) => s.progress),
    );

    final List<AdventureLevel> levels =
        AdventureCatalog.inWorld(_selectedWorld);
    final int worldStars = _countWorldStars(progress, levels);
    final int maxWorldStars = levels.length * 3;

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
                          'MACƏRA',
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
                  const SizedBox(height: 8),
                  _WorldSelector(
                    palette: palette,
                    selectedWorld: _selectedWorld,
                    onSelect: (w) => setState(() => _selectedWorld = w),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AdventureCatalog.worldNames[_selectedWorld - 1],
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star_rounded,
                              color: palette.accent,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$worldStars / $maxWorldStars',
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: levels.length,
                      itemBuilder: (context, index) {
                        final AdventureLevel level = levels[index];
                        final bool unlocked =
                            progress.isUnlocked(level.id);
                        final bool completed =
                            progress.isCompleted(level.id);
                        final int stars = progress.starsFor(level.id);

                        return _LevelTile(
                          palette: palette,
                          level: level,
                          unlocked: unlocked,
                          completed: completed,
                          stars: stars,
                          onTap: unlocked
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => AdventureGameScreen(
                                        levelId: level.id,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _countWorldStars(
    AdventureProgress progress,
    List<AdventureLevel> levels,
  ) {
    int total = 0;
    for (final lvl in levels) {
      total += progress.starsFor(lvl.id);
    }
    return total;
  }
}

class _WorldSelector extends StatelessWidget {
  const _WorldSelector({
    required this.palette,
    required this.selectedWorld,
    required this.onSelect,
  });

  final ThemePalette palette;
  final int selectedWorld;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List<Widget>.generate(AdventureCatalog.worldCount, (i) {
          final int world = i + 1;
          final bool selected = world == selectedWorld;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onSelect(world),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? palette.accent.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? palette.accent
                          : Colors.white.withValues(alpha: 0.08),
                      width: selected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'DÜNYA $world',
                      style: TextStyle(
                        color: selected
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
            ),
          );
        }),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  const _LevelTile({
    required this.palette,
    required this.level,
    required this.unlocked,
    required this.completed,
    required this.stars,
    required this.onTap,
  });

  final ThemePalette palette;
  final AdventureLevel level;
  final bool unlocked;
  final bool completed;
  final int stars;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg = !unlocked
        ? Colors.white.withValues(alpha: 0.03)
        : completed
            ? palette.accent.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.08);

    final Color border = !unlocked
        ? Colors.white.withValues(alpha: 0.05)
        : completed
            ? palette.accent
            : Colors.white.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!unlocked)
              Icon(
                Icons.lock_rounded,
                color: palette.textSecondary.withValues(alpha: 0.5),
                size: 20,
              )
            else
              Text(
                '${level.indexInWorld}',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            if (unlocked && stars > 0) ...<Widget>[
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(3, (i) {
                  return Icon(
                    i < stars
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: i < stars
                        ? palette.accent
                        : palette.textSecondary.withValues(alpha: 0.4),
                    size: 10,
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
