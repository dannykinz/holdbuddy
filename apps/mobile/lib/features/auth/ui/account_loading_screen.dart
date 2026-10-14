import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_request.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_hero.dart';
import 'widgets/auth_scaffold.dart';

class AccountLoadingScreen extends ConsumerStatefulWidget {
  const AccountLoadingScreen({super.key, this.hasRequest = false});
  final bool hasRequest;

  @override
  ConsumerState<AccountLoadingScreen> createState() =>
      _AccountLoadingScreenState();
}

class _AccountLoadingScreenState extends ConsumerState<AccountLoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = ref.read(AuthController.provider);
      if (state.isBusy) return;
      if (widget.hasRequest && state.outcome != null) {
        _finish(state.outcome);
        return;
      }
      unawaited(
        ref
            .read(AuthController.provider.notifier)
            .submit(const AuthRequest(AuthOperation.retry)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(AuthController.provider, (previous, next) {
      if (next.isBusy ||
          next.outcome == null ||
          ModalRoute.isCurrentOf(context) != true)
        return;
      _finish(next.outcome);
    });
    final l10n = AppLocalizations.of(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && ref.read(AuthController.provider).isBusy)
          ref.read(AuthController.provider.notifier).cancel();
      },
      child: AuthScaffold(
        route: AppRoute.accountLoading,
        onBack: _back,
        fallback: AppRoute.signIn,
        content: [
          const AuthHero(icon: 'lock'),
          HbHeading(
            title: l10n.authLoadingTitle,
            description: l10n.authLoadingBody,
          ),
        ],
        actions: [
          HbButton(label: l10n.authSigningIn, onPressed: null, loading: true),
        ],
      ),
    );
  }

  void _finish(AuthOutcome? outcome) {
    if (outcome == AuthOutcome.signedIn) {
      context.goNamed(AppRoute.today.name);
      return;
    }
    if (outcome == AuthOutcome.offline) {
      context.replaceNamed(AppRoute.accountOffline.name);
      return;
    }
    if (outcome == AuthOutcome.cancelled) {
      context.replaceNamed(AppRoute.googleCancelled.name);
      return;
    }
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(AppRoute.signIn.name);
  }

  void _back() {
    ref.read(AuthController.provider.notifier).cancel();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(AppRoute.signIn.name);
  }
}
