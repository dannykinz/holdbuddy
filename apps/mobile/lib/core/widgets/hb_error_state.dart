import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';
import '../logging/logger.dart';
import 'hb_button.dart';
import 'hb_category.dart';
import 'hb_empty_state.dart';

/// Requires a bounded height so the recovery action stays at the bottom.
class HbErrorState extends StatefulWidget {
  const HbErrorState({
    super.key,
    required this.error,
    required this.onRetry,
    this.stackTrace,
    this.title,
    this.description,
  });
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback onRetry;
  final String? title;
  final String? description;

  @override
  State<HbErrorState> createState() => _HbErrorStateState();
}

class _HbErrorStateState extends State<HbErrorState> {
  @override
  void initState() {
    super.initState();
    _logError();
  }

  @override
  void didUpdateWidget(covariant HbErrorState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error != widget.error) _logError();
  }

  void _logError() =>
      logError(widget.error, widget.stackTrace ?? StackTrace.current);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Tokens.space20,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: HbEmptyState(
                title: widget.title ?? strings.loadErrorHeading,
                description: widget.description ?? strings.loadErrorDescription,
                asset: 'assets/icons/error_refresh.svg',
                category: HbCategory.green,
              ),
            ),
          ),
          HbButton(label: strings.tryAgain, onPressed: widget.onRetry),
        ],
      ),
    );
  }
}
