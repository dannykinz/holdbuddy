import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_path_status.dart';

class HbPathNode extends StatelessWidget {
  const HbPathNode({
    super.key,
    required this.status,
    required this.number,
    required this.label,
    required this.onPressed,
    this.asset,
    this.fill,
  });
  final HbPathStatus status;
  final String number;
  final String label;
  final VoidCallback onPressed;
  final String? asset;
  final Color? fill;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final current = status == HbPathStatus.current;
    return SizedBox.square(
      dimension: current ? WidgetTokens.nodeGlowSize : WidgetTokens.nodeSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (current)
            SvgPicture.asset(
              'assets/icons/path_glow.svg',
              excludeFromSemantics: true,
              colorFilter: ColorFilter.mode(colors.tint, BlendMode.srcIn),
            ),
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Tokens.ink.withValues(
                    alpha: WidgetTokens.nodeShadowOpacity,
                  ),
                  offset: const Offset(0, WidgetTokens.buttonEdge),
                ),
              ],
            ),
            child: _button(colors),
          ),
        ],
      ),
    );
  }

  Widget _button(AppColors colors) => Semantics(
    label: label,
    excludeSemantics: true,
    button: true,
    onTap: onPressed,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor:
            fill ??
            switch (status) {
              HbPathStatus.done => colors.green,
              HbPathStatus.current => colors.primary,
              HbPathStatus.ahead => colors.surface,
            },
        padding: EdgeInsets.zero,
        shape: const CircleBorder(),
        minimumSize: Size.square(
          status == HbPathStatus.current
              ? WidgetTokens.currentNodeSize
              : WidgetTokens.nodeSize,
        ),
        side: status == HbPathStatus.ahead
            ? BorderSide(color: colors.line, width: WidgetTokens.activeWidth)
            : BorderSide.none,
      ),
      child: _content(colors),
    ),
  );

  Widget _content(AppColors colors) {
    if (status == HbPathStatus.ahead) {
      return Text(
        number,
        style: WidgetTokens.nodeNumber.copyWith(color: colors.subtle),
      );
    }
    return SvgPicture.asset(
      asset ??
          (status == HbPathStatus.done
              ? 'assets/icons/path_check.svg'
              : 'assets/icons/path_book.svg'),
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
    );
  }
}
