import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';
import 'hb_error_state.dart';

class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.builder,
    required this.onRetry,
    this.isEmpty,
    this.empty,
  }) : assert((isEmpty == null) == (empty == null));
  final AsyncValue<T> value;
  final Widget Function(BuildContext, T) builder;
  final VoidCallback onRetry;
  final bool Function(T)? isEmpty;
  final Widget? empty;

  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnRefresh: false,
    data: (data) => _data(context, data),
    error: (error, stackTrace) =>
        HbErrorState(error: error, stackTrace: stackTrace, onRetry: onRetry),
    loading: () => Center(
      child: CircularProgressIndicator(
        color: AppColors.of(context).accent,
        strokeWidth: WidgetTokens.activeWidth,
        semanticsLabel: AppLocalizations.of(context).loading,
      ),
    ),
  );

  Widget _data(BuildContext context, T data) {
    final emptyWidget = empty;
    if (emptyWidget != null && isEmpty?.call(data) == true) return emptyWidget;
    return builder(context, data);
  }
}
