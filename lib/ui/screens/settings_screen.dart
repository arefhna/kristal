import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme_palette.dart';
import '../../data/models/achievement_progress.dart';
import '../../data/models/adventure_progress.dart';
import '../../state/providers.dart';
import '../painters/background_painter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemePalette palette = ref.watch(themePaletteProvider);
    final bool hapticsEnabled = ref.watch(
      settingsControllerProvider.select((s) => s.hapticsEnabled),
    );
    final bool soundEnabled = ref.watch(
      settingsControllerProvider.select((s) => s.soundEnabled),
    );
    final ThemeId currentTheme = ref.watch(
      settingsControllerProvider.select((s) => s.themeId),
    );
    final AdventureProgress adventure = ref.watch(
      adventureControllerProvider.select((s) => s.progress),
    );
    final AchievementProgress achievements = ref.watch(
      achievementControllerProvider.select((s) => s.progress),
    );

    bool isThemeUnlocked(ThemePalette p) {
      if (p.unlockStarsRequired > 0 &&
          adventure.totalStars < p.unlockStarsRequired) {
        return false;
      }
      if (p.unlockAchievementId != null &&
          !achievements.isUnlocked(p.unlockAchievementId!)) {
        return false;
      }
      return true;
    }

    String unlockLabel(ThemePalette p) {
      if (p.unlockStarsRequired > 0) {
        return '${p.unlockStarsRequired} ulduz';
      }
      if (p.unlockAchievementId != null) {
        return 'Nailiyyət';
      }
      return '';
    }

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
                            'AYARLAR',
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
                    _SectionTitle(text: 'MÖVZU', palette: palette),
                    const SizedBox(height: 12),
                    ...ThemePalette.all.map((p) {
                      final bool unlocked = isThemeUnlocked(p);
                      final bool selected = p.id == currentTheme;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _ThemeRow(
                          palette: p,
                          selected: selected,
                          unlocked: unlocked,
                          unlockLabel: unlockLabel(p),
                          onTap: unlocked
                              ? () {
                                  ref
                                      .read(settingsControllerProvider.notifier)
                                      .updateTheme(p.id);
                                }
                              : null,
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    _SectionTitle(text: 'TƏTBİQ', palette: palette),
                    const SizedBox(height: 12),
                    _ToggleRow(
                      palette: palette,
                      label: 'Vibrasiya',
                      subtitle: 'İncə toxunma hissi',
                      value: hapticsEnabled,
                      onChanged: (_) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .toggleHaptics();
                      },
                    ),
                    const SizedBox(height: 8),
                    _ToggleRow(
                      palette: palette,
                      label: 'Səs',
                      subtitle: 'Oyun səsləri (tezliklə)',
                      value: soundEnabled,
                      onChanged: (_) {
                        ref
                            .read(settingsControllerProvider.notifier)
                            .toggleSound();
                      },
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Text(
                        'Kristal v0.1.0',
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text, required this.palette});

  final String text;
  final ThemePalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: TextStyle(
          color: palette.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 3.0,
        ),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  const _ThemeRow({
    required this.palette,
    required this.selected,
    required this.unlocked,
    required this.unlockLabel,
    required this.onTap,
  });

  final ThemePalette palette;
  final bool selected;
  final bool unlocked;
  final String unlockLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? palette.accent.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? palette.accent
                : Colors.white.withValues(alpha: 0.08),
            width: selected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    palette.blockColors[0],
                    palette.blockColors[2 % palette.blockColors.length],
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: unlocked
                  ? null
                  : Icon(
                      Icons.lock_rounded,
                      color: Colors.black.withValues(alpha: 0.55),
                      size: 20,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    palette.name,
                    style: TextStyle(
                      color: unlocked
                          ? palette.textPrimary
                          : palette.textSecondary.withValues(alpha: 0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  if (!unlocked && unlockLabel.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      unlockLabel,
                      style: TextStyle(
                        color: palette.textSecondary.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: palette.accent,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.palette,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final ThemePalette palette;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: palette.accent,
          ),
        ],
      ),
    );
  }
}
