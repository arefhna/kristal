import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_palette.dart';
import 'state/providers.dart';
import 'state/settings/settings_state.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/widgets/achievement_toast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1B3A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final StorageService storage = await StorageService.create();

  runApp(
    ProviderScope(
      overrides: <Override>[
        storageServiceProvider.overrideWithValue(storage),
      ],
      child: const KristalApp(),
    ),
  );
}

class KristalApp extends ConsumerWidget {
  const KristalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SettingsState settings = ref.watch(settingsControllerProvider);
    final ThemePalette palette = ThemePalette.byId(settings.themeId);
    final String? toastTitle = ref.watch(
      achievementControllerProvider.select((s) => s.pendingToast),
    );

    return MaterialApp(
      title: 'Kristal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromPalette(palette),
      home: const SplashScreen(),
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            if (child != null) child,
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: AchievementToastHost(
                  palette: palette,
                  title: toastTitle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AchievementToastHost extends ConsumerStatefulWidget {
  const AchievementToastHost({
    super.key,
    required this.palette,
    required this.title,
  });

  final ThemePalette palette;
  final String? title;

  @override
  ConsumerState<AchievementToastHost> createState() =>
      _AchievementToastHostState();
}

class _AchievementToastHostState extends ConsumerState<AchievementToastHost> {
  bool _visible = false;

  @override
  void didUpdateWidget(covariant AchievementToastHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.title != null && widget.title != oldWidget.title) {
      setState(() => _visible = true);
      Future<void>.delayed(const Duration(milliseconds: 2200), () {
        if (!mounted) return;
        setState(() => _visible = false);
        Future<void>.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          ref.read(achievementControllerProvider.notifier).clearToast();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.title == null) return const SizedBox.shrink();
    return AchievementToast(
      palette: widget.palette,
      title: widget.title!,
      isVisible: _visible,
    );
  }
}
