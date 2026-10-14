import 'package:flutter/material.dart';

import '../../features/auth/ui/account_form_screen.dart';
import '../../features/auth/ui/account_loading_screen.dart';
import '../../features/auth/ui/account_offline_screen.dart';
import '../../features/auth/ui/google_screen.dart';
import '../../features/auth/ui/password_result_screen.dart';
import '../../features/auth/ui/password_screen.dart';
import '../../features/auth/ui/sign_out_screen.dart';
import '../../features/auth/ui/verify_email_screen.dart';
import 'app_route.dart';

abstract final class AuthRoutes {
  static Widget? screen(AppRoute route, {bool hasRequest = false}) =>
      switch (route) {
        AppRoute.signUp => const AccountFormScreen(createAccount: true),
        AppRoute.signIn => const AccountFormScreen(createAccount: false),
        AppRoute.verifyEmail => const VerifyEmailScreen(),
        AppRoute.forgotPassword => const PasswordScreen(reset: false),
        AppRoute.resetPassword => const PasswordScreen(reset: true),
        AppRoute.accountLoading => AccountLoadingScreen(hasRequest: hasRequest),
        AppRoute.googleHandoff => const GoogleScreen(),
        AppRoute.googleCancelled => const GoogleScreen(cancelled: true),
        AppRoute.passwordEmailSent => const PasswordResultScreen(saved: false),
        AppRoute.passwordSaved => const PasswordResultScreen(saved: true),
        AppRoute.accountOffline => const AccountOfflineScreen(),
        AppRoute.signOutConfirm => const SignOutScreen(),
        _ => null,
      };
}
