import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../focus/domain/study_mode.dart';
import '../../../focus/logic/focus_controller.dart';

class SessionModeSheet extends ConsumerWidget {
  const SessionModeSheet({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(FocusController.provider);
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space12,
      children: [
        _mode(
          context,
          ref,
          StudyMode.study,
          l10n.sessionStudyMode,
          l10n.sessionStudyModeBody,
          state.mode == StudyMode.study,
        ),
        _mode(
          context,
          ref,
          StudyMode.tasks,
          l10n.sessionTaskMode,
          l10n.sessionTaskModeBody,
          state.mode == StudyMode.tasks,
        ),
        SwitchListTile(
          value: state.silence,
          onChanged: ref.read(FocusController.provider.notifier).silence,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Tokens.space16,
          ),
          tileColor: AppColors.of(context).soft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
          ),
          secondary: _icon(
            context,
            'moon',
            AppColors.of(context).green,
            AppColors.of(context).greenSoft,
          ),
          title: Text(l10n.sessionSilence, style: Tokens.strong),
          subtitle: Text(l10n.sessionSilenceBody, style: Tokens.small),
        ),
        HbButton(
          label: l10n.startSession,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }

  Widget _mode(
    BuildContext context,
    WidgetRef ref,
    StudyMode mode,
    String title,
    String body,
    bool selected,
  ) {
    final colors = AppColors.of(context);
    final study = mode == StudyMode.study;
    return Material(
      color: selected ? colors.skySoft : colors.soft,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
        side: selected
            ? BorderSide(color: colors.sky, width: WidgetTokens.focusWidth)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(Tokens.space16),
        selected: selected,
        onTap: () => ref.read(FocusController.provider.notifier).mode(mode),
        leading: _icon(
          context,
          study ? 'book' : 'task',
          study ? colors.sky : colors.orange,
          study ? colors.surface : colors.orangeSoft,
        ),
        title: Text(title, style: Tokens.strong.copyWith(color: colors.text)),
        subtitle: Text(body, style: Tokens.small.copyWith(color: colors.muted)),
        trailing: _radio(context, selected),
      ),
    );
  }

  Widget _radio(BuildContext context, bool selected) {
    if (!selected) return _unselectedRadio(context);
    return SvgPicture.asset(
      'assets/icons/focus_radio.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(AppColors.of(context).sky, BlendMode.srcIn),
    );
  }

  Widget _icon(BuildContext context, String name, Color color, Color fill) =>
      Container(
        width: Tokens.navItemHeight,
        height: Tokens.navItemHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(Tokens.radiusIconTile),
        ),
        child: SvgPicture.asset(
          'assets/icons/focus_mode_$name.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      );

  Widget _unselectedRadio(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: DailyTokens.modeRadioSize,
      height: DailyTokens.modeRadioSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.line, width: WidgetTokens.focusWidth),
      ),
    );
  }
}
