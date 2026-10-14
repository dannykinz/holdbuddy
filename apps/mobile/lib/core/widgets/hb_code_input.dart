import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbCodeInput extends StatefulWidget {
  const HbCodeInput({
    super.key,
    required this.label,
    required this.controller,
    this.onCompleted,
    this.autofocus = false,
    this.labelStyle,
  });
  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;
  final bool autofocus;
  final TextStyle? labelStyle;

  @override
  State<HbCodeInput> createState() => _HbCodeInputState();
}

class _HbCodeInputState extends State<HbCodeInput> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: WidgetTokens.fieldLabelGap,
    children: [
      Text(
        widget.label,
        style: (widget.labelStyle ?? Tokens.label).copyWith(
          color: AppColors.of(context).muted,
        ),
      ),
      SizedBox(
        height: WidgetTokens.codeHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: ExcludeSemantics(
                child: ValueListenableBuilder(
                  valueListenable: widget.controller,
                  builder: (context, value, child) => _boxes(value),
                ),
              ),
            ),
            Positioned.fill(child: _input()),
          ],
        ),
      ),
    ],
  );

  Widget _input() => Focus(
    onFocusChange: (focused) => setState(() => _focused = focused),
    child: Opacity(
      opacity: WidgetTokens.hiddenOpacity,
      alwaysIncludeSemantics: true,
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autofocus,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        decoration: InputDecoration(labelText: widget.label),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(WidgetTokens.codeLength),
        ],
        onChanged: (code) {
          if (code.length == WidgetTokens.codeLength)
            widget.onCompleted?.call(code);
        },
      ),
    ),
  );

  Widget _boxes(TextEditingValue value) {
    final digits = value.text.replaceAll(RegExp('[^0-9]'), '');
    return Row(
      spacing: Tokens.space8,
      children: [
        for (var index = 0; index < WidgetTokens.codeLength; index++)
          Expanded(child: _box(index, digits)),
      ],
    );
  }

  Widget _box(int index, String digits) {
    final colors = AppColors.of(context);
    final active = _focused && index == digits.length;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? colors.surface : colors.soft,
        borderRadius: BorderRadius.circular(Tokens.radiusField),
        border: active
            ? Border.all(color: colors.accent, width: WidgetTokens.activeWidth)
            : null,
      ),
      child: index < digits.length
          ? Text(
              digits[index],
              style: WidgetTokens.codeDigit.copyWith(color: colors.text),
            )
          : active
          ? Container(
              width: WidgetTokens.codeCursorWidth,
              height: WidgetTokens.codeCursorHeight,
              color: colors.accent,
            )
          : null,
    );
  }
}
