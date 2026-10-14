import 'package:flutter/material.dart';

import '../../features/notes/ui/new_note_screen.dart';
import '../../features/notes/ui/note_detail_screen.dart';
import '../../features/notes/ui/note_recall_screen.dart';
import '../../features/notes/ui/notes_screen.dart';
import '../../features/plan/ui/plan_screen.dart';
import '../../features/today/ui/alerts_screen.dart';
import '../../features/today/ui/progress_screen.dart';
import 'app_route.dart';

abstract final class AroundRoutes {
  static Widget? screen(AppRoute route, {String? noteId, int? noteChapter}) =>
      switch (route) {
        AppRoute.plan => const PlanScreen(),
        AppRoute.notes => const NotesScreen(),
        AppRoute.noteDetail => NoteDetailScreen(noteId: noteId),
        AppRoute.noteRecall => NoteRecallScreen(noteId: noteId),
        AppRoute.noteNew => NewNoteScreen(chapter: noteChapter),
        AppRoute.alerts => const AlertsScreen(),
        AppRoute.progress => const ProgressScreen(),
        _ => null,
      };
}
