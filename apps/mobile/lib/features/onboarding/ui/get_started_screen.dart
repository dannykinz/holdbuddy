import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import 'widgets/first_run_heading.dart';
import 'widgets/today_illustration.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    key: const ValueKey(AppRoute.getStarted),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Tokens.screenMargin,
          Tokens.space16,
          Tokens.screenMargin,
          OnboardingTokens.bottomInset,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(child: _content(context)),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _content(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: Alignment.centerLeft, child: _back(context)),
        const SizedBox(height: OnboardingTokens.previewTopGap),
        const TodayIllustration(),
        const SizedBox(height: Tokens.space20),
        FirstRunHeading(
          before: l10n.getStartedBefore,
          accent: l10n.getStartedAccent,
          after: l10n.getStartedAfter,
          description: l10n.getStartedBody,
        ),
        const SizedBox(height: Tokens.space20),
        _accountActions(context),
        const Spacer(),
        HbButton(
          label: l10n.continueOffline,
          variant: HbButtonVariant.ghost,
          onPressed: () => context.pushNamed(AppRoute.accountOffline.name),
        ),
      ],
    );
  }

  Widget _accountActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HbButton(
          label: l10n.continueGoogle,
          google: true,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.pushNamed(AppRoute.googleHandoff.name),
        ),
        const SizedBox(height: Tokens.space20),
        HbButton(
          label: l10n.continueEmail,
          onPressed: () => context.pushNamed(AppRoute.signUp.name),
        ),
        const SizedBox(height: Tokens.space20),
        _signIn(context),
      ],
    );
  }

  Widget _back(BuildContext context) => IconButton.filledTonal(
    tooltip: AppLocalizations.of(context).back,
    style: IconButton.styleFrom(
      backgroundColor: AppColors.of(context).soft,
      minimumSize: const Size.square(Tokens.minTouchTarget),
    ),
    onPressed: () {
      if (context.canPop()) {
        context.pop();
        return;
      }
      context.goNamed(AppRoute.onboardingReturn.name);
    },
    icon: SvgPicture.asset(
      'assets/icons/onboarding_back.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).text,
        BlendMode.srcIn,
      ),
    ),
  );

  Widget _signIn(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return TextButton(
      onPressed: () => context.pushNamed(AppRoute.signIn.name),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: l10n.existingAccount,
              style: TextStyle(color: colors.muted),
            ),
            TextSpan(
              text: l10n.signIn,
              style: TextStyle(
                color: colors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: OnboardingTokens.nudgeMessage.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
