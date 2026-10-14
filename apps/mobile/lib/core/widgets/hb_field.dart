import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbField extends StatelessWidget {
  const HbField({
    super.key,
    required this.label,
    required this.controller,
    this.focusNode,
    this.errorText,
    this.hintText,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.suffixIcon,
    this.textInputAction,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.labelStyle,
    this.minimumHeight = Tokens.buttonHeight,
    this.fillColor,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? errorText;
  final String? hintText;
  final bool enabled;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool readOnly;
  final TextStyle? labelStyle;
  final double minimumHeight;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: WidgetTokens.fieldLabelGap,
      children: [
        Text(
          label,
          style: (labelStyle ?? Tokens.label).copyWith(color: colors.muted),
        ),
        Semantics(
          label: label,
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            readOnly: readOnly,
            obscureText: obscureText,
            maxLines: maxLines,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            validator: validator,
            style: Tokens.body.copyWith(
              color: enabled ? colors.text : colors.subtle,
            ),
            cursorColor: colors.accent,
            decoration: _decoration(colors),
          ),
        ),
      ],
    );
  }

  InputDecoration _decoration(AppColors colors) => InputDecoration(
    filled: true,
    fillColor: fillColor ?? colors.soft,
    hintText: hintText,
    errorText: errorText,
    suffixIcon: suffixIcon,
    hintStyle: Tokens.body.copyWith(color: colors.subtle),
    errorStyle: Tokens.small.copyWith(color: colors.accent),
    contentPadding: const EdgeInsets.all(Tokens.space16),
    enabledBorder: _border(colors.soft, 0),
    focusedBorder: _border(colors.accent, WidgetTokens.focusWidth),
    errorBorder: _border(colors.accent, WidgetTokens.focusWidth),
    focusedErrorBorder: _border(colors.accent, WidgetTokens.focusWidth),
    disabledBorder: _border(colors.line, WidgetTokens.focusWidth),
    constraints: BoxConstraints(minHeight: minimumHeight),
  );

  OutlineInputBorder _border(Color color, double width) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(Tokens.radiusField),
    borderSide: width == 0
        ? BorderSide.none
        : BorderSide(color: color, width: width),
  );
}
