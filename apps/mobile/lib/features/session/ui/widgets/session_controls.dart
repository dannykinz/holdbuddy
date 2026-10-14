import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../material/domain/material_kind.dart';
import '../../../material/logic/material_controller.dart';
import '../../logic/session_controller.dart';

class SessionControls extends ConsumerWidget {
  const SessionControls({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final first = ref.watch(
      SessionController.provider.select((state) => state.isFirst),
    );
    final pdf = ref
        .watch(planMaterialsProvider)
        .where((item) => item.kind == MaterialKind.pdf)
        .firstOrNull;
    return Row(
      spacing: Tokens.space12,
      children: [
        if (!first)
          Flexible(
            child: HbButton(
              label: l10n.sessionPause,
              variant: HbButtonVariant.secondary,
              onPressed: ref.read(SessionController.provider.notifier).pause,
            ),
          ),
        Expanded(
          flex: 2,
          child: HbButton(
            label: pdf == null
                ? l10n.sessionOpenMaterial
                : l10n.materialOpenPdf,
            variant: HbButtonVariant.secondary,
            onPressed: () => context.pushNamed(
              pdf == null
                  ? AppRoute.materialLibrary.name
                  : AppRoute.readerPdf.name,
              extra: pdf?.id,
            ),
          ),
        ),
      ],
    );
  }
}
