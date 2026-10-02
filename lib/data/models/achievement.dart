enum AchievementCategory {
  score,
  gameplay,
  daily,
  adventure,
  special,
}

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconName,
    required this.requiredValue,
  });

  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final String iconName;
  final int requiredValue;
}
