import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../domain/today_view.dart';
import '../logic/today_controller.dart';
import 'widgets/today_header.dart';
import 'widgets/today_main.dart';
import 'widgets/today_recovery.dart';
import 'widgets/today_week.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(TodayController.provider);
    return Scaffold(
      key: const ValueKey(AppRoute.today),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            Tokens.screenMargin,
            Tokens.space16,
            Tokens.screenMargin,
            DailyTokens.tabBottomInset,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Tokens.space24,
            children: [
              const TodayHeader(),
              if (view != TodayView.empty && view != TodayView.loading)
                const TodayWeek(),
              if (view == TodayView.ready)
                const TodayMain()
              else
                TodayRecovery(view: view),
            ],
          ),
        ),
      ),
    );
  }
}
