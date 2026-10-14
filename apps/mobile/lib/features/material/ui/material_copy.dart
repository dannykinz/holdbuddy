import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_category.dart';
import '../domain/linked_material.dart';
import '../domain/material_kind.dart';

abstract final class MaterialCopy {
  static HbCategory category(MaterialKind kind) => switch (kind) {
    MaterialKind.pdf => HbCategory.purple,
    MaterialKind.document => HbCategory.orange,
    MaterialKind.audio => HbCategory.pink,
    MaterialKind.link => HbCategory.sky,
  };
  static String details(AppLocalizations l, LinkedMaterial material) {
    final size = material.sizeMb.toStringAsFixed(1);
    if (material.kind == MaterialKind.link) return l.materialOpenLink;
    return material.kind == MaterialKind.audio
        ? l.materialMinutes(material.extent, size)
        : l.materialPages(material.extent, size);
  }

  static String progress(AppLocalizations l, LinkedMaterial material) {
    if (material.position == 0) return l.materialNotStarted;
    return material.kind == MaterialKind.audio
        ? l.materialAudioPosition(material.position ~/ 60, material.extent)
        : l.materialPagePosition(material.position, material.extent);
  }

  static String time(int seconds) {
    final duration = Duration(seconds: seconds);
    return duration.inMinutes.toString().padLeft(2, '0') +
        ':' +
        (seconds % 60).toString().padLeft(2, '0');
  }
}
