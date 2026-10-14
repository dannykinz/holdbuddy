import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';
import 'hb_tab.dart';

class HbNavBar extends StatelessWidget {
  const HbNavBar({required this.selected, required this.onSelected, super.key});

  final HbTab selected;
  final ValueChanged<HbTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Tokens.navRadius),
        boxShadow: [_shadow(colors, active: false)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Tokens.navRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: Tokens.navBlur,
            sigmaY: Tokens.navBlur,
          ),
          child: _bar(context, colors),
        ),
      ),
    );
  }

  Widget _bar(BuildContext context, AppColors colors) => LayoutBuilder(
    builder: (context, constraints) => Container(
      height: Tokens.navHeight,
      padding: const EdgeInsets.symmetric(horizontal: Tokens.navInset),
      decoration: BoxDecoration(
        color: colors.glass,
        border: Border.all(color: colors.glassEdge),
        borderRadius: BorderRadius.circular(Tokens.navRadius),
      ),
      child: _items(context, _activePadding(context, constraints.maxWidth)),
    ),
  );

  Widget _items(BuildContext context, EdgeInsets padding) => Material(
    type: MaterialType.transparency,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: Tokens.navGap,
      children: [for (final tab in HbTab.values) _item(context, tab, padding)],
    ),
  );

  Widget _item(BuildContext context, HbTab tab, EdgeInsets padding) {
    final isSelected = tab == selected;
    final label = tab.label(AppLocalizations.of(context));
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      onTap: () => onSelected(tab),
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: InkWell(
          onTap: () => onSelected(tab),
          customBorder: Tokens.chipShape,
          child: SizedBox(
            width: isSelected ? null : Tokens.minTouchTarget,
            height: Tokens.minTouchTarget,
            child: _content(context, tab, isSelected, padding),
          ),
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    HbTab tab,
    bool active,
    EdgeInsets padding,
  ) {
    final colors = AppColors.of(context);
    return Center(
      child: Container(
        height: Tokens.navItemHeight,
        padding: active ? padding : null,
        decoration: active ? _activeDecoration(colors) : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Tokens.navLabelGap,
          children: [
            _icon(tab, colors, active),
            if (active)
              Text(
                tab.label(AppLocalizations.of(context)),
                style: Tokens.strong.copyWith(color: colors.text),
              ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _activePadding(BuildContext context, double width) {
    if (!width.isFinite) return Tokens.navActivePadding;
    final label = TextPainter(
      text: TextSpan(
        text: selected.label(AppLocalizations.of(context)),
        style: Tokens.strong,
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final otherTabs =
        (HbTab.values.length - 1) * (Tokens.minTouchTarget + Tokens.navGap);
    const insets = 2 * (Tokens.navInset + WidgetTokens.lineWidth);
    const icon = Tokens.navIconSize + Tokens.navLabelGap;
    final available = width - insets - otherTabs - icon - label.width;
    label.dispose();
    final proportion = (available / Tokens.navActivePadding.horizontal).clamp(
      0.0,
      1.0,
    );
    return EdgeInsets.only(
      left: Tokens.navActivePadding.left * proportion,
      right: Tokens.navActivePadding.right * proportion,
    );
  }

  Widget _icon(HbTab tab, AppColors colors, bool active) => SvgPicture.asset(
    tab.iconAsset(selected: active),
    width: Tokens.navIconSize,
    height: Tokens.navIconSize,
    excludeFromSemantics: true,
    colorFilter: ColorFilter.mode(
      active ? colors.text : colors.muted,
      BlendMode.srcIn,
    ),
  );

  BoxDecoration _activeDecoration(AppColors colors) => BoxDecoration(
    color: colors.glassActive,
    borderRadius: BorderRadius.circular(Tokens.navItemRadius),
    boxShadow: [_shadow(colors, active: true)],
  );

  BoxShadow _shadow(AppColors colors, {required bool active}) => BoxShadow(
    color: (active ? colors.activeShadow : colors.floatingShadow).withValues(
      alpha: active ? Tokens.navActiveShadowOpacity : Tokens.navShadowOpacity,
    ),
    offset: active ? Tokens.navActiveShadowOffset : Tokens.navShadowOffset,
    blurRadius: active ? Tokens.navActiveShadowBlur : Tokens.navShadowBlur,
  );
}
