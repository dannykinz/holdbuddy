import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/linked_material.dart';
import '../../logic/audio_controller.dart';
import '../../logic/material_controller.dart';
import '../../logic/material_note_chapter.dart';

class AudioControls extends ConsumerWidget {
  const AudioControls({super.key, required this.material});
  final LinkedMaterial material;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _speed(context, ref),
      _skip(context, ref, back: true),
      _play(context, ref),
      _skip(context, ref, back: false),
      _note(context, ref),
    ],
  );
  Widget _skip(BuildContext context, WidgetRef ref, {required bool back}) =>
      SizedBox.square(
        dimension: MaterialTokens.skipButton,
        child: IconButton(
          tooltip: back
              ? AppLocalizations.of(context).materialSkipBack
              : AppLocalizations.of(context).materialSkipForward,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.of(context).soft,
          ),
          onPressed: () => ref
              .read(MaterialController.provider.notifier)
              .seek(
                material,
                material.position +
                    (back
                        ? -MaterialTokens.skipSeconds
                        : MaterialTokens.skipSeconds),
              ),
          icon: _skipIcon(context, back),
        ),
      );
  Widget _play(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(AudioController.provider).playing;
    final colors = AppColors.of(context);
    return SizedBox.square(
      dimension: MaterialTokens.audioButton,
      child: IconButton(
        tooltip: playing
            ? AppLocalizations.of(context).materialPause
            : AppLocalizations.of(context).materialPlay,
        onPressed: ref.read(AudioController.provider.notifier).toggle,
        style: IconButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
        ),
        icon: playing
            ? SvgPicture.asset(
                'assets/icons/audio_pause.svg',
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(
                  colors.onPrimary,
                  BlendMode.srcIn,
                ),
              )
            : const Icon(Icons.play_arrow, size: DailyTokens.heroIconSize),
      ),
    );
  }

  Widget _note(BuildContext context, WidgetRef ref) => IconButton(
    tooltip: AppLocalizations.of(context).materialWriteNote,
    onPressed: () => context.pushNamed(
      AppRoute.noteNew.name,
      extra: ref.read(materialNoteChapterProvider(material)),
    ),
    style: IconButton.styleFrom(
      backgroundColor: AppColors.of(context).purpleSoft,
    ),
    icon: SvgPicture.asset(
      'assets/icons/audio_pen.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).purple,
        BlendMode.srcIn,
      ),
    ),
  );
  Widget _speed(BuildContext context, WidgetRef ref) {
    final state = ref.watch(AudioController.provider);
    final l = AppLocalizations.of(context);
    return PopupMenuButton<double>(
      tooltip: l.materialPlaybackSpeed,
      onSelected: ref.read(AudioController.provider.notifier).speed,
      initialValue: state.speed,
      itemBuilder: (context) => [
        for (final speed in MaterialTokens.playbackSpeeds)
          PopupMenuItem(
            value: speed,
            child: Text(l.materialPlaybackSpeedValue(speed.toString())),
          ),
      ],
      child: _speedLabel(context, state.speed),
    );
  }

  Widget _skipIcon(BuildContext context, bool back) => SvgPicture.asset(
    back ? 'assets/icons/audio_back15.svg' : 'assets/icons/audio_forward15.svg',
    excludeFromSemantics: true,
    colorFilter: ColorFilter.mode(AppColors.of(context).text, BlendMode.srcIn),
  );
  Widget _speedLabel(BuildContext context, double speed) => SizedBox.square(
    dimension: Tokens.minTouchTarget,
    child: Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Tokens.space8,
          vertical: Tokens.space8,
        ),
        decoration: ShapeDecoration(
          color: AppColors.of(context).soft,
          shape: Tokens.chipShape,
        ),
        child: Text(
          AppLocalizations.of(context)
              .materialPlaybackSpeedValue(speed.toString()),
          style: MaterialTokens.compact,
        ),
      ),
    ),
  );
}
