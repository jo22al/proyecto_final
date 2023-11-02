import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/theme/app_theme.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => false);

// colot list inmutable
final colorListProvider = Provider((ref) => colorList);

// simple int
final selectedColorProvider = StateProvider<int>((ref) => 0);

// AppTheme Custom
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void updateSelectedColor(int index) {
    state = state.copyWith(selectedColor: index);
  }
}
