import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(OnboardingTokens.splashDelay, _openOnboarding);
  }

  void _openOnboarding() {
    if (!mounted || ModalRoute.isCurrentOf(context) != true) return;
    context.goNamed(AppRoute.onboardingContract.name);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colors.primary,
        systemNavigationBarColor: colors.primary,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: const ValueKey(AppRoute.splash),
        backgroundColor: colors.primary,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: Tokens.space16,
            children: [
              SvgPicture.asset(
                'assets/icons/brand_mark.svg',
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(
                  colors.onPrimary,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                AppLocalizations.of(context).brandName,
                style: Tokens.display.copyWith(color: colors.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
