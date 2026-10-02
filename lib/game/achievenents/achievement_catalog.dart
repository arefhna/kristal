import '../../data/models/achievement.dart';

class AchievementCatalog {
  AchievementCatalog._();

  static const List<Achievement> all = <Achievement>[
    Achievement(
      id: 'first_game',
      title: 'İlk Addım',
      description: 'İlk oyununu oyna',
      category: AchievementCategory.gameplay,
      iconName: 'play',
      requiredValue: 1,
    ),
    Achievement(
      id: 'score_500',
      title: 'Başlanğıc',
      description: 'Bir oyunda 500 xal topla',
      category: AchievementCategory.score,
      iconName: 'star',
      requiredValue: 500,
    ),
    Achievement(
      id: 'score_1000',
      title: 'Yaxşı Oyunçu',
      description: 'Bir oyunda 1000 xal topla',
      category: AchievementCategory.score,
      iconName: 'star',
      requiredValue: 1000,
    ),
    Achievement(
      id: 'score_2500',
      title: 'Ustad',
      description: 'Bir oyunda 2500 xal topla',
      category: AchievementCategory.score,
      iconName: 'star',
      requiredValue: 2500,
    ),
    Achievement(
      id: 'score_5000',
      title: 'Kristal Kral',
      description: 'Bir oyunda 5000 xal topla',
      category: AchievementCategory.score,
      iconName: 'crown',
      requiredValue: 5000,
    ),
    Achievement(
      id: 'combo_5',
      title: 'Combo Ustası',
      description: '5-lik combo et',
      category: AchievementCategory.gameplay,
      iconName: 'fire',
      requiredValue: 5,
    ),
    Achievement(
      id: 'combo_8',
      title: 'Combo Kralı',
      description: '8-lik combo et',
      category: AchievementCategory.gameplay,
      iconName: 'fire',
      requiredValue: 8,
    ),
    Achievement(
      id: 'lines_100',
      title: 'Xətt Ustası',
      description: 'Ümumilikdə 100 xətt sil',
      category: AchievementCategory.gameplay,
      iconName: 'grid',
      requiredValue: 100,
    ),
    Achievement(
      id: 'lines_500',
      title: 'Xətt Hökmdarı',
      description: 'Ümumilikdə 500 xətt sil',
      category: AchievementCategory.gameplay,
      iconName: 'grid',
      requiredValue: 500,
    ),
    Achievement(
      id: 'games_10',
      title: 'Sadiq Oyunçu',
      description: '10 oyun oyna',
      category: AchievementCategory.gameplay,
      iconName: 'games',
      requiredValue: 10,
    ),
    Achievement(
      id: 'master_10_games',
      title: 'Sadiq Oyunçu II',
      description: '10 oyun tamamla',
      category: AchievementCategory.gameplay,
      iconName: 'games',
      requiredValue: 10,
    ),
    Achievement(
      id: 'games_50',
      title: 'Veteran',
      description: '50 oyun oyna',
      category: AchievementCategory.gameplay,
      iconName: 'games',
      requiredValue: 50,
    ),
    Achievement(
      id: 'daily_first',
      title: 'İlk Çağırış',
      description: 'İlk gündəlik çağırışı oyna',
      category: AchievementCategory.daily,
      iconName: 'calendar',
      requiredValue: 1,
    ),
    Achievement(
      id: 'daily_streak_3',
      title: '3 Gün Seriya',
      description: '3 gün ardıcıl gündəlik oyna',
      category: AchievementCategory.daily,
      iconName: 'fire',
      requiredValue: 3,
    ),
    Achievement(
      id: 'daily_streak_7',
      title: 'Həftəlik',
      description: '7 gün ardıcıl gündəlik oyna',
      category: AchievementCategory.daily,
      iconName: 'fire',
      requiredValue: 7,
    ),
    Achievement(
      id: 'daily_streak_30',
      title: 'Ay Ustası',
      description: '30 gün ardıcıl gündəlik oyna',
      category: AchievementCategory.daily,
      iconName: 'fire',
      requiredValue: 30,
    ),
    Achievement(
      id: 'adventure_first',
      title: 'Macəraçı',
      description: 'İlk macəra səviyyəsini tamamla',
      category: AchievementCategory.adventure,
      iconName: 'map',
      requiredValue: 1,
    ),
    Achievement(
      id: 'adventure_world_1',
      title: 'Vadi Fatehi',
      description: '1-ci dünyanı tamamla',
      category: AchievementCategory.adventure,
      iconName: 'map',
      requiredValue: 10,
    ),
    Achievement(
      id: 'adventure_world_2',
      title: 'Buz Qıran',
      description: '2-ci dünyanı tamamla',
      category: AchievementCategory.adventure,
      iconName: 'map',
      requiredValue: 20,
    ),
    Achievement(
      id: 'adventure_world_3',
      title: 'Ulduz Fatehi',
      description: '3-cü dünyanı tamamla',
      category: AchievementCategory.adventure,
      iconName: 'crown',
      requiredValue: 30,
    ),
    Achievement(
      id: 'stars_50',
      title: '50 Ulduz',
      description: 'Macəradan 50 ulduz topla',
      category: AchievementCategory.adventure,
      iconName: 'star',
      requiredValue: 50,
    ),
    Achievement(
      id: 'stars_90',
      title: 'Ulduz Kolleksiyaçısı',
      description: 'Macəradan 90 ulduz topla',
      category: AchievementCategory.adventure,
      iconName: 'star',
      requiredValue: 90,
    ),
    Achievement(
      id: 'perfect_clear',
      title: 'Təmiz Lövhə',
      description: 'Lövhəni tam təmizlə',
      category: AchievementCategory.special,
      iconName: 'sparkle',
      requiredValue: 1,
    ),
  ];

  static Achievement? byId(String id) {
    for (final a in all) {
      if (a.id == id) return a;
    }
    return null;
  }

  static int get total => all.length;
}
