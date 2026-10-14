import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/hb_create_button.dart';
import '../../core/widgets/hb_nav_bar.dart';
import '../../core/widgets/hb_tab.dart';
import '../../features/plan/domain/plan_status.dart';
import '../../features/plan/domain/plan_view.dart';
import '../../features/plan/logic/plan_controller.dart';
import '../../features/settings/domain/settings_pane.dart';
import '../../features/settings/logic/settings_navigation.dart';
import '../theme/app_colors.dart';
import '../theme/tokens.dart';
import 'app_route.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (navigationShell.currentIndex ==
            AppRoute.tabs.indexOf(AppRoute.settings) &&
        ref.watch(SettingsNavigation.provider) != SettingsPane.home)
      return navigationShell;
    if (navigationShell.currentIndex == AppRoute.tabs.indexOf(AppRoute.plan) &&
        (ref.watch(PlanController.provider) == PlanView.updated ||
            ref.watch(chosenPlanProvider).status == PlanStatus.archived))
      return navigationShell;
    return Scaffold(
      body: Stack(
        children: [
          navigationShell,
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: DailyTokens.navFadeHeight,
                child: SvgPicture.asset(
                  'assets/icons/daily_nav_fade.svg',
                  fit: BoxFit.fill,
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(
                    AppColors.of(context).bg,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: Tokens.screenMargin,
            right: Tokens.screenMargin,
            bottom: 0,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: Tokens.space24),
              child: LayoutBuilder(builder: _navigation),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigation(BuildContext context, BoxConstraints constraints) => Wrap(
    alignment: WrapAlignment.center,
    spacing: Tokens.space8,
    runSpacing: Tokens.space8,
    children: [
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth),
        child: HbNavBar(
          selected: HbTab.values[navigationShell.currentIndex],
          onSelected: (tab) => navigationShell.goBranch(tab.index),
        ),
      ),
      HbCreateButton(onPressed: () => _create(context)),
    ],
  );
  Future<void> _create(BuildContext context) async {
    final route = await context.pushNamed<AppRoute>(AppRoute.todayCreate.name);
    if (!context.mounted || route == null) return;
    await context.pushNamed<void>(route.name);
  }
}
