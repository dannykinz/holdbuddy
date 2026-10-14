import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../focus/logic/focus_controller.dart';
import '../../../material/domain/material_kind.dart';
import '../../../material/logic/material_controller.dart';
import '../../../material/ui/material_copy.dart';
import '../../../tasks/ui/task_checklist.dart';
import '../../logic/session_controller.dart';

class SessionTasks extends ConsumerWidget {
  const SessionTasks({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focus = ref.watch(FocusController.provider);
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space8,
      children: [
        TaskChecklist(
          chapter: ref.watch(SessionController.provider).chapterNumber,
        ),
        if (focus.active) _audio(context, ref),
        Material(
          color: colors.soft,
          borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
          child: ListTile(
            onTap: () => context.pushNamed(
              AppRoute.noteNew.name,
              extra: ref.read(SessionController.provider).chapterNumber,
            ),
            leading: SvgPicture.asset(
              'assets/icons/focus_note.svg',
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
            ),
            title: Text(l10n.createNote, style: Tokens.strong),
            trailing: SvgPicture.asset(
              'assets/icons/daily_chevron.svg',
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(colors.subtle, BlendMode.srcIn),
            ),
          ),
        ),
      ],
    );
  }

  Widget _audioIcon(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: DailyTokens.rowTileSize,
      height: DailyTokens.rowTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(DailyTokens.rowTileRadius),
      ),
      child: SvgPicture.asset(
        'assets/icons/focus_audio.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.pink, BlendMode.srcIn),
      ),
    );
  }

  Widget _playButton(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(Tokens.space12),
      decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
      child: SvgPicture.asset(
        'assets/icons/focus_play.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
      ),
    );
  }

  Widget _audio(BuildContext context, WidgetRef ref) {
    final audio = ref
        .watch(planMaterialsProvider)
        .where((item) => item.kind == MaterialKind.audio)
        .firstOrNull;
    if (audio == null) return const SizedBox.shrink();
    final colors = AppColors.of(context);
    return Material(
      color: colors.pinkSoft,
      borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
      child: ListTile(
        onTap: () =>
            context.pushNamed(AppRoute.playerAudio.name, extra: audio.id),
        leading: _audioIcon(context),
        title: Text(audio.title, style: Tokens.strong),
        subtitle: Text(
          AppLocalizations.of(context)
              .sessionContinueAudio(MaterialCopy.time(audio.position)),
          style: Tokens.meta,
        ),
        trailing: _playButton(context),
      ),
    );
  }
}
