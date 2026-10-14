import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';

class AccountDeletedScreen extends StatelessWidget {
  const AccountDeletedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Tokens.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Semantics(
                header: true,
                child: Text(
                  l.accountDeletedTitle,
                  textAlign: TextAlign.center,
                  style: Tokens.headline,
                ),
              ),
              const SizedBox(height: Tokens.space20),
              Text(
                l.accountDeletedBody,
                textAlign: TextAlign.center,
                style: Tokens.body.copyWith(color: AppColors.of(context).muted),
              ),
              const Spacer(),
              HbButton(
                label: l.accountBackStart,
                onPressed: () => context.goNamed(AppRoute.getStarted.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
