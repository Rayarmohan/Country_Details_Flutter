import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

class AppThemeState {
  final ThemeMode mode;
  final Color accentColor;
  final double fontScale;

  const AppThemeState({
    this.mode = ThemeMode.system,
    this.accentColor = Colors.teal,
    this.fontScale = 1.0,
  });

  AppThemeState copyWith({ThemeMode? mode, Color? accentColor, double? fontScale}) {
    return AppThemeState(
      mode: mode ?? this.mode,
      accentColor: accentColor ?? this.accentColor,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}

class AppThemeNotifier extends Notifier<AppThemeState> {
  @override
  AppThemeState build() => const AppThemeState();

  void setThemeMode(ThemeMode mode) => state = state.copyWith(mode: mode);
  void setAccentColor(Color color) => state = state.copyWith(accentColor: color);
  void setFontScale(double scale) => state = state.copyWith(fontScale: scale);
}

final themeProvider = NotifierProvider<AppThemeNotifier, AppThemeState>(
  AppThemeNotifier.new,
);

final lightThemeProvider = Provider<ThemeData>((ref) {
  final state = ref.watch(themeProvider);
  return AppTheme.buildLightTheme(state.accentColor, state.fontScale);
});

final darkThemeProvider = Provider<ThemeData>((ref) {
  final state = ref.watch(themeProvider);
  return AppTheme.buildDarkTheme(state.accentColor, state.fontScale);
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(themeProvider.select((s) => s.mode));
});
