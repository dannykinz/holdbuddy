import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/hb_category.dart';
import '../domain/note_category.dart';

extension NotePalette on NoteCategory {
  ColorPair colors(AppColors colors) => switch (this) {
    NoteCategory.purple => HbCategory.purple.colors(colors),
    NoteCategory.orange => HbCategory.orange.colors(colors),
    NoteCategory.sky => HbCategory.sky.colors(colors),
  };
}
