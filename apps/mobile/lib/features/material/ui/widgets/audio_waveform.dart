import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/linked_material.dart';
import '../../logic/material_controller.dart';
import '../material_copy.dart';

class AudioWaveform extends ConsumerWidget {
  const AudioWaveform({super.key, required this.material});
  final LinkedMaterial material;
  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    height: MaterialTokens.waveformHeight,
    child: Stack(
      alignment: Alignment.center,
      children: [
        ExcludeSemantics(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: MaterialTokens.waveformGap,
            children: [
              for (final (index, height) in MaterialTokens.waveform.indexed)
                _bar(context, index, height),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 0,
            thumbShape: SliderComponentShape.noThumb,
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: material.position.toDouble(),
            max: material.limit.toDouble(),
            label: MaterialCopy.time(material.position),
            semanticFormatterCallback: (value) => AppLocalizations.of(context)
                .materialAudioTiming(
                  MaterialCopy.time(value.round()),
                  MaterialCopy.time(material.limit),
                ),
            onChanged: (value) => ref
                .read(MaterialController.provider.notifier)
                .seek(material, value.round()),
          ),
        ),
      ],
    ),
  );
  Widget _bar(BuildContext context, int index, double height) => Container(
    width: MaterialTokens.waveformWidth,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(MaterialTokens.waveformRadius),
      color:
          index / MaterialTokens.waveform.length <
              material.position / material.limit
          ? AppColors.of(context).pink
          : AppColors.of(context).line,
    ),
  );
}
