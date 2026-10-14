import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_path_node.dart';
import '../../../../core/widgets/hb_path_status.dart';
import '../../domain/plan_chapter.dart';
import '../../domain/plan_view.dart';
import '../../logic/plan_controller.dart';

class PlanPath extends ConsumerWidget {
  const PlanPath({super.key, required this.view});
  final PlanView view;
  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
    builder: (context, constraints) {
      final scale =
          MediaQuery.textScalerOf(context)
              .scale(Tokens.small.fontSize ?? Tokens.space16) /
          (Tokens.small.fontSize ?? Tokens.space16);
      final horizontal = constraints.maxWidth / PlanTokens.pathWidth;
      final chapters = ref.watch(planChaptersProvider(view));
      return SizedBox(
        height: PlanTokens.pathHeight * scale,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _road(context, horizontal, scale, done: false),
            _road(context, horizontal, scale, done: true),
            for (var index = 0; index < chapters.length; index++)
              ..._chapter(context, chapters[index], index, horizontal, scale),
          ],
        ),
      );
    },
  );
  Widget _road(
    BuildContext context,
    double horizontal,
    double vertical, {
    required bool done,
  }) {
    final variant = view == PlanView.history
        ? 'history_'
        : view == PlanView.complete
        ? 'complete_'
        : '';
    return Positioned(
      left: 0,
      top: 0,
      child: Transform.scale(
        scaleX: horizontal,
        scaleY: vertical,
        alignment: Alignment.topLeft,
        child: SvgPicture.asset(
          done
              ? 'assets/icons/plan_${variant}road_done.svg'
              : 'assets/icons/plan_${variant}road.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            done ? AppColors.of(context).greenSoft : AppColors.of(context).soft,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  List<Widget> _chapter(
    BuildContext context,
    PlanChapter chapter,
    int index,
    double xScale,
    double yScale,
  ) {
    final current = view == PlanView.history
        ? index == 6
        : view == PlanView.complete
        ? index == 6
        : index == 3;
    final done =
        view == PlanView.complete ||
        (view == PlanView.history ? index < 6 : index < 3);
    final size = current ? WidgetTokens.nodeGlowSize : WidgetTokens.nodeSize;
    final center = PlanTokens.centers[index];
    final x = center.dx * xScale;
    final y = center.dy * yScale;
    return [
      Positioned(
        left: x - size / 2,
        top: y - size / 2,
        child: _node(context, chapter, current, done),
      ),
      Positioned(
        top: y - PlanTokens.labelOffset * yScale,
        left: index < 4 ? 0 : x + size / 2 + PlanTokens.labelGap,
        right: index < 4
            ? PlanTokens.pathWidth * xScale - x + size / 2 + PlanTokens.labelGap
            : 0,
        child: _label(context, chapter, current, done, index < 4),
      ),
    ];
  }

  Widget _label(
    BuildContext context,
    PlanChapter chapter,
    bool current,
    bool done,
    bool left,
  ) {
    return Column(
      crossAxisAlignment: left
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      spacing: DailyTokens.copyGap,
      children: [
        _title(context, chapter, current, done, left),
        Text(
          _caption(context, chapter, current, done),
          style: Tokens.meta.copyWith(
            color: current
                ? AppColors.of(context).orange
                : AppColors.of(context).subtle,
          ),
        ),
      ],
    );
  }

  Widget _node(
    BuildContext context,
    PlanChapter chapter,
    bool current,
    bool done,
  ) {
    return HbPathNode(
      status: current
          ? HbPathStatus.current
          : done
          ? HbPathStatus.done
          : HbPathStatus.ahead,
      asset: chapter.number == 0 ? 'assets/icons/plan_finish_flag.svg' : null,
      fill: view == PlanView.complete ? AppColors.of(context).green : null,
      number: chapter.number.toString(),
      label: chapter.name,
      onPressed: () => chapter.number == 0
          ? context.pushNamed(AppRoute.progress.name)
          : context.pushNamed(AppRoute.chapter.name, extra: chapter.number),
    );
  }

  Widget _title(
    BuildContext context,
    PlanChapter chapter,
    bool current,
    bool done,
    bool left,
  ) {
    return Text(
      chapter.number == 0
          ? chapter.name
          : done || current
          ? '${chapter.number}. ${chapter.name}'
          : chapter.name,
      textAlign: left ? TextAlign.right : TextAlign.left,
      style: Tokens.label.copyWith(
        color: done || current
            ? AppColors.of(context).text
            : AppColors.of(context).muted,
      ),
    );
  }

  String _caption(
    BuildContext context,
    PlanChapter chapter,
    bool current,
    bool done,
  ) {
    final l10n = AppLocalizations.of(context);
    return chapter.number == 0
        ? l10n.planEarlyFinish(
            DateFormat.MMMd(l10n.localeName).format(chapter.date),
          )
        : current
        ? l10n.planTonight
        : done
        ? l10n.planDoneOn(DateFormat.MMMd(l10n.localeName).format(chapter.date))
        : DateFormat('EEE d MMM', l10n.localeName).format(chapter.date);
  }
}
