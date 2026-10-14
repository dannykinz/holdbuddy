import 'package:flutter/material.dart';

import '../../features/focus/ui/focus_permission_screen.dart';
import '../../features/material/ui/material_unavailable_screen.dart';
import '../../features/plan/ui/chapter_screen.dart';
import '../../features/session/ui/missed_session_screen.dart';
import '../../features/session/ui/session_screen.dart';
import '../../features/session/ui/welcome_back_screen.dart';
import '../../features/today/ui/today_screen.dart';
import 'app_route.dart';

abstract final class DailyRoutes {
  static Widget? screen(AppRoute route, {int? chapter, String? materialId}) =>
      switch (route) {
        AppRoute.today => const TodayScreen(),
        AppRoute.session => SessionScreen(chapterNumber: chapter),
        AppRoute.sessionSaved => const SessionScreen(receipt: true),
        AppRoute.missedSession => const MissedSessionScreen(),
        AppRoute.welcomeBack => const WelcomeBackScreen(),
        AppRoute.materialUnavailable => MaterialUnavailableScreen(
          materialId: materialId,
        ),
        AppRoute.sessionChooseMode => ChapterScreen(
          chooseMode: true,
          chapterNumber: chapter,
        ),
        AppRoute.chapter => ChapterScreen(chapterNumber: chapter),
        AppRoute.chapterAddTask => ChapterScreen(
          addTask: true,
          chapterNumber: chapter,
        ),
        AppRoute.focusPermission => FocusPermissionScreen(
          chapterNumber: chapter,
        ),
        _ => null,
      };
}
