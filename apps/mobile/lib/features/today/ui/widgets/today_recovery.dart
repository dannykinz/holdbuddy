import 'package:flutter/material.dart';

import '../../domain/today_view.dart';
import 'today_done.dart';
import 'today_empty.dart';
import 'today_first.dart';
import 'today_loading.dart';
import 'today_offline.dart';
import 'today_rest.dart';

class TodayRecovery extends StatelessWidget {
  const TodayRecovery({super.key, required this.view});
  final TodayView view;
  @override
  Widget build(BuildContext context) => switch (view) {
    TodayView.first => const TodayFirst(),
    TodayView.rest => const TodayRest(),
    TodayView.empty => const TodayEmpty(),
    TodayView.offline => const TodayOffline(),
    TodayView.loading => const TodayLoading(),
    _ => TodayDone(view: view),
  };
}
