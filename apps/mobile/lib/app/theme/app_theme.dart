import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'tokens.dart';

abstract final class AppTheme {
  static final light = _build(Brightness.light, Tokens.light);
  static final dark = _build(Brightness.dark, Tokens.dark);

  static const _buttonTheme = FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(Tokens.buttonHeight)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(Tokens.radiusButton)),
        ),
      ),
    ),
  );

  static ThemeData _build(Brightness brightness, AppColors colors) => ThemeData(
    brightness: brightness,
    colorScheme: _colorScheme(brightness, colors),
    scaffoldBackgroundColor: colors.bg,
    canvasColor: colors.bg,
    cardColor: colors.surface,
    cardTheme: CardThemeData(
      color: colors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
        side: BorderSide(color: colors.line),
      ),
    ),
    dividerColor: colors.line,
    disabledColor: colors.subtle,
    shadowColor: colors.shadow,
    fontFamily: Tokens.fontFamily,
    textTheme: _textTheme(colors),
    filledButtonTheme: _buttonTheme,
    extensions: [colors],
  );

  static ColorScheme _colorScheme(Brightness brightness, AppColors colors) =>
      ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        primaryContainer: colors.tint,
        onPrimaryContainer: colors.accent,
        secondary: colors.accent,
        onSecondary: colors.bg,
        secondaryContainer: colors.tint,
        onSecondaryContainer: colors.text,
        error: colors.error,
        onError: colors.bg,
        errorContainer: colors.errorBg,
        onErrorContainer: colors.error,
        surface: colors.surface,
        onSurface: colors.text,
        surfaceContainer: colors.soft,
        onSurfaceVariant: colors.muted,
        outline: colors.line,
        outlineVariant: colors.tintLine,
        shadow: colors.shadow,
      );

  static TextTheme _textTheme(AppColors colors) => TextTheme(
    displayLarge: Tokens.timer.copyWith(color: colors.text),
    displayMedium: Tokens.display.copyWith(color: colors.text),
    displaySmall: Tokens.display.copyWith(color: colors.text),
    headlineLarge: Tokens.headline.copyWith(color: colors.text),
    headlineMedium: Tokens.headline.copyWith(color: colors.text),
    headlineSmall: Tokens.title.copyWith(color: colors.text),
    titleLarge: Tokens.title.copyWith(color: colors.text),
    titleMedium: Tokens.strong.copyWith(color: colors.text),
    titleSmall: Tokens.label.copyWith(color: colors.muted),
    bodyLarge: Tokens.body.copyWith(color: colors.text),
    bodyMedium: Tokens.body.copyWith(color: colors.muted),
    bodySmall: Tokens.small.copyWith(color: colors.muted),
    labelLarge: Tokens.strong.copyWith(color: colors.text),
    labelMedium: Tokens.label.copyWith(color: colors.muted),
    labelSmall: Tokens.meta.copyWith(color: colors.subtle),
  );
}
