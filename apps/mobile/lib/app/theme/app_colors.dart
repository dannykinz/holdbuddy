import 'package:flutter/material.dart';

import 'app_color.dart';

class AppColors extends ThemeExtension<AppColors> {
  AppColors(Map<AppColor, Color> colors) : _colors = Map.unmodifiable(colors) {
    if (colors.length != AppColor.values.length) {
      throw ArgumentError('Every semantic colour token must be supplied.');
    }
  }

  final Map<AppColor, Color> _colors;

  static AppColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    if (colors == null) {
      throw StateError('AppColors is missing from the theme.');
    }
    return colors;
  }

  Color operator [](AppColor token) =>
      _colors[token] ??
      (throw StateError('Missing colour token: ${token.name}'));

  Color get bg => this[AppColor.bg];
  Color get surface => this[AppColor.surface];
  Color get soft => this[AppColor.soft];
  Color get line => this[AppColor.line];
  Color get text => this[AppColor.text];
  Color get muted => this[AppColor.muted];
  Color get subtle => this[AppColor.subtle];
  Color get primary => this[AppColor.primary];
  Color get onPrimary => this[AppColor.onPrimary];
  Color get primaryEdge => this[AppColor.primaryEdge];
  Color get accent => this[AppColor.accent];
  Color get tint => this[AppColor.tint];
  Color get tintLine => this[AppColor.tintLine];
  Color get nav => this[AppColor.nav];
  Color get navActive => this[AppColor.navActive];
  Color get error => this[AppColor.error];
  Color get errorBg => this[AppColor.errorBg];
  Color get success => this[AppColor.success];
  Color get successBg => this[AppColor.successBg];
  Color get shadow => this[AppColor.shadow];
  Color get purple => this[AppColor.purple];
  Color get purpleSoft => this[AppColor.purpleSoft];
  Color get orange => this[AppColor.orange];
  Color get orangeSoft => this[AppColor.orangeSoft];
  Color get sky => this[AppColor.sky];
  Color get skySoft => this[AppColor.skySoft];
  Color get green => this[AppColor.green];
  Color get greenSoft => this[AppColor.greenSoft];
  Color get pink => this[AppColor.pink];
  Color get pinkSoft => this[AppColor.pinkSoft];
  Color get glass => this[AppColor.glass];
  Color get glassEdge => this[AppColor.glassEdge];
  Color get glassActive => this[AppColor.glassActive];

  Color get floatingShadow => this[AppColor.floatingShadow];
  Color get activeShadow => this[AppColor.activeShadow];

  @override
  AppColors copyWith({Map<AppColor, Color>? colors}) =>
      AppColors({..._colors, ...?colors});

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors({
      for (final token in AppColor.values)
        token: Color.lerp(this[token], other[token], t) ?? this[token],
    });
  }
}
