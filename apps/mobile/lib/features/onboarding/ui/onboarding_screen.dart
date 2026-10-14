import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import 'widgets/contract_illustration.dart';
import 'widgets/first_run_heading.dart';
import 'widgets/return_illustration.dart';
import 'widgets/witness_illustration.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, required this.step})
    : assert(step >= 0 && step < OnboardingTokens.slideCount);
  final int step;
  static const routes = [
    AppRoute.onboardingContract,
    AppRoute.onboardingWitness,
    AppRoute.onboardingReturn,
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    key: ValueKey(routes[step]),
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

  Widget _content(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(alignment: Alignment.centerRight, child: _skip(context)),
      const SizedBox(height: Tokens.space24),
      switch (step) {
        0 => const ContractIllustration(),
        1 => const WitnessIllustration(),
        _ => const ReturnIllustration(),
      },
      const SizedBox(height: Tokens.space20),
      _heading(AppLocalizations.of(context)),
      const SizedBox(height: Tokens.space20),
      const Spacer(),
      _progress(context),
      const SizedBox(height: Tokens.space12),
      HbButton(
        label: step == OnboardingTokens.slideCount - 1
            ? AppLocalizations.of(context).letsBegin
            : AppLocalizations.of(context).continueAction,
        onPressed: () => context.pushNamed(
          step == OnboardingTokens.slideCount - 1
              ? AppRoute.getStarted.name
              : routes[step + 1].name,
        ),
      ),
    ],
  );

  Widget _skip(BuildContext context) => SizedBox.square(
    dimension: Tokens.minTouchTarget,
    child: TextButton(
      onPressed: () => context.pushNamed(AppRoute.getStarted.name),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        foregroundColor: AppColors.of(context).text,
        textStyle: WidgetTokens.chipLabel,
      ),
      child: Text(AppLocalizations.of(context).skip),
    ),
  );

  Widget _heading(AppLocalizations l10n) => switch (step) {
    0 => FirstRunHeading(
      before: l10n.onboardingContractBefore,
      accent: l10n.onboardingContractAccent,
      after: l10n.headlinePeriod,
      description: l10n.onboardingContractBody,
    ),
    1 => FirstRunHeading(
      before: l10n.onboardingWitnessBefore,
      accent: l10n.onboardingWitnessAccent,
      after: l10n.headlinePeriod,
      description: l10n.onboardingWitnessBody,
    ),
    _ => FirstRunHeading(
      before: l10n.onboardingReturnBefore,
      accent: l10n.onboardingReturnAccent,
      after: l10n.headlinePeriod,
      description: l10n.onboardingReturnBody,
    ),
  };

  Widget _progress(BuildContext context) => Semantics(
    label: AppLocalizations.of(context)
        .contractStep(step + 1, OnboardingTokens.slideCount),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: OnboardingTokens.dotSize,
      children: [
        for (var index = 0; index < OnboardingTokens.slideCount; index++)
          Container(
            width: index == step
                ? OnboardingTokens.dotWidth
                : OnboardingTokens.dotSize,
            height: OnboardingTokens.dotSize,
            decoration: BoxDecoration(
              color: index == step
                  ? AppColors.of(context).primary
                  : AppColors.of(context).line,
              borderRadius: BorderRadius.circular(OnboardingTokens.dotRadius),
            ),
          ),
      ],
    ),
  );
}
