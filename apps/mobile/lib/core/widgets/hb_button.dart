import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';
import 'hb_button_variant.dart';

class HbButton extends StatefulWidget {
  const HbButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = HbButtonVariant.primary,
    this.loading = false,
    this.google = false,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final HbButtonVariant variant;
  final bool loading;
  final bool google;
  final bool destructive;

  @override
  State<HbButton> createState() => _HbButtonState();
}

class _HbButtonState extends State<HbButton> {
  final _states = WidgetStatesController();
  bool get _hasFace => widget.onPressed != null || widget.loading;
  bool get _primary => widget.variant == HbButtonVariant.primary;

  @override
  void initState() {
    super.initState();
    _states.addListener(_rebuild);
  }

  void _rebuild() {
    if (WidgetsBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      liveRegion: widget.loading,
      value: widget.loading ? AppLocalizations.of(context).loading : null,
      child: DecoratedBox(
        decoration: _edge(colors),
        child: FilledButton(
          statesController: _states,
          clipBehavior: Clip.antiAlias,
          onPressed: widget.loading ? null : widget.onPressed,
          style: _style(colors),
          child: _content(),
        ),
      ),
    );
  }

  BoxDecoration _edge(AppColors colors) => BoxDecoration(
    borderRadius: BorderRadius.circular(Tokens.radiusButton),
    boxShadow: [
      if (_primary && _hasFace)
        BoxShadow(
          color: widget.destructive ? colors.error : colors.primaryEdge,
          offset: Offset(
            0,
            _states.value.contains(WidgetState.pressed)
                ? WidgetTokens.pressedEdge
                : WidgetTokens.buttonEdge,
          ),
        ),
    ],
  );

  Color _background(AppColors colors) {
    if (!_hasFace) return colors.soft;
    if (_primary) return widget.destructive ? colors.error : colors.primary;
    if (widget.variant == HbButtonVariant.secondary) return colors.surface;
    return colors.surface.withValues(alpha: WidgetTokens.hiddenOpacity);
  }

  Color _foreground(AppColors colors) {
    if (!_hasFace) return colors.subtle;
    if (widget.destructive && !_primary) return colors.error;
    return _primary ? colors.onPrimary : colors.text;
  }

  ButtonStyle _style(AppColors colors) => ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(_background(colors)),
    foregroundColor: WidgetStatePropertyAll(_foreground(colors)),
    textStyle: WidgetStatePropertyAll(Tokens.strong),
    elevation: const WidgetStatePropertyAll(0),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        horizontal: Tokens.space20,
        vertical: Tokens.space16,
      ),
    ),
    side: WidgetStatePropertyAll(
      widget.variant == HbButtonVariant.secondary
          ? BorderSide(color: colors.line)
          : BorderSide.none,
    ),
    backgroundBuilder: _highlight,
    animationDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : WidgetTokens.motionDuration,
  );

  Widget _highlight(
    BuildContext context,
    Set<WidgetState> states,
    Widget? child,
  ) {
    if (!_primary || !_hasFace) return child ?? const SizedBox.shrink();
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Tokens.buttonHighlight)),
      ),
      child: child,
    );
  }

  Widget _content() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: WidgetTokens.buttonGap,
    children: [
      if (widget.google)
        SvgPicture.asset('assets/icons/google.svg', excludeFromSemantics: true),
      Flexible(child: Text(widget.label, textAlign: TextAlign.center)),
    ],
  );
}
