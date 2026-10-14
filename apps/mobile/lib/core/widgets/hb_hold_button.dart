import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_button.dart';

class HbHoldButton extends StatefulWidget {
  const HbHoldButton({
    super.key,
    required this.label,
    required this.holdingLabel,
    required this.onCommitted,
    this.enabled = true,
    this.onHoldingChanged,
  });
  final String label;
  final String holdingLabel;
  final VoidCallback onCommitted;
  final ValueChanged<bool>? onHoldingChanged;
  final bool enabled;

  @override
  State<HbHoldButton> createState() => _HbHoldButtonState();
}

class _HbHoldButtonState extends State<HbHoldButton>
    with SingleTickerProviderStateMixin {
  late final _progress = AnimationController(
    vsync: this,
    duration: ContractTokens.holdDuration,
    animationBehavior: AnimationBehavior.preserve,
  )..addStatusListener(_status);
  bool _holding = false;
  bool _committed = false;

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HbHoldButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) _cancel();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: widget.enabled,
    label: widget.label,
    onTap: widget.enabled ? _toggleAccessibleHold : null,
    child: Listener(
      onPointerDown: widget.enabled ? (_) => _start() : null,
      onPointerUp: (_) => _cancel(),
      onPointerCancel: (_) => _cancel(),
      onPointerMove: (event) => _checkBounds(event.localPosition),
      child: Stack(
        children: [
          ExcludeSemantics(
            child: HbButton(
              label: _holding ? widget.holdingLabel : widget.label,
              onPressed: widget.enabled ? () {} : null,
            ),
          ),
          Positioned.fill(child: IgnorePointer(child: _fill(context))),
        ],
      ),
    ),
  );

  Widget _fill(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(Tokens.radiusButton),
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) => FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: _progress.value,
          child: ColoredBox(
            color: AppColors.of(context).onPrimary
                .withValues(alpha: ContractTokens.holdFillOpacity),
          ),
        ),
      ),
    );
  }

  void _start() {
    if (_committed || _holding || !widget.enabled) return;
    setState(() => _holding = true);
    widget.onHoldingChanged?.call(true);
    _progress.forward(from: 0);
  }

  void _cancel() {
    if (_committed || !_holding) return;
    _progress.reset();
    setState(() => _holding = false);
    widget.onHoldingChanged?.call(false);
  }

  void _toggleAccessibleHold() => _holding ? _cancel() : _start();

  void _checkBounds(Offset position) {
    final size = context.size;
    if (size == null) return;
    if (!(Offset.zero & size).contains(position)) _cancel();
  }

  void _status(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted || _committed) return;
    _committed = true;
    widget.onCommitted();
  }
}
