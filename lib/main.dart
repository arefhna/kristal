import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_palette.dart';
import 'state/providers.dart';
import 'state/settings/settings_state.dart';
import 'ui/screens/splash_screen.dart';

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

    return MaterialApp(
      title: 'Kristal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.fromPalette(palette),
      home: const SplashScreen(),
    );
  }
}
