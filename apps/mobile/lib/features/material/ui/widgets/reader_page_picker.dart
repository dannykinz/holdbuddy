import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/material_controller.dart';

class ReaderPagePicker extends ConsumerWidget {
  const ReaderPagePicker({super.key, required this.materialId});
  final String materialId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final material = ref.watch(selectedMaterialProvider(materialId));
    if (material == null || material.extent < 1) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final page = material.position.clamp(1, material.extent);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Tokens.space12,
      children: [
        Text(
          l.materialPagePosition(page.toInt(), material.extent),
          style: Tokens.strong,
        ),
        Slider(
          value: page.toDouble(),
          min: 1,
          max: material.extent.toDouble(),
          divisions: material.extent > 1 ? material.extent - 1 : null,
          label: page.toString(),
          onChanged: (value) => ref
              .read(MaterialController.provider.notifier)
              .seek(material, value.round()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: page <= 1
                  ? null
                  : () => ref
                        .read(MaterialController.provider.notifier)
                        .seek(material, page.toInt() - 1),
              child: Text(l.materialPreviousPage),
            ),
            TextButton(
              onPressed: page >= material.extent
                  ? null
                  : () => ref
                        .read(MaterialController.provider.notifier)
                        .seek(material, page.toInt() + 1),
              child: Text(l.materialNextPage),
            ),
          ],
        ),
      ],
    );
  }
}
