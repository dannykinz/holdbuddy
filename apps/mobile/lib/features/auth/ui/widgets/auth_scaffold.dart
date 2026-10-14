import 'package:flutter/material.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_back_button.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.route,
    required this.content,
    required this.actions,
    this.gap = Tokens.space20,
    this.onBack,
    this.fallback = AppRoute.getStarted,
  });
  final AppRoute route;
  final List<Widget> content;
  final List<Widget> actions;
  final double gap;
  final VoidCallback? onBack;
  final AppRoute fallback;

  @override
  Widget build(BuildContext context) => HbPageScaffold(
    key: ValueKey(route),
    topBar: Align(
      alignment: Alignment.centerLeft,
      child: HbBackButton(onPressed: onBack, fallback: fallback),
    ),
    gap: gap,
    content: content,
    actions: actions,
    footnote: Text(
      AppLocalizations.of(context).authPreview,
      textAlign: TextAlign.center,
      style: AuthTokens.finePrint.copyWith(color: AppColors.of(context).muted),
    ),
  );
}
