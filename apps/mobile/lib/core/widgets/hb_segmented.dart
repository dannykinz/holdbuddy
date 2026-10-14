import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbSegmented extends StatelessWidget {
  const HbSegmented({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  }) : assert(labels.length > 1),
       assert(selected >= 0 && selected < labels.length);
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: ShapeDecoration(
      color: AppColors.of(context).soft,
      shape: Tokens.chipShape,
    ),
    child: Row(
      spacing: WidgetTokens.segmentInset,
      children: [
        for (var index = 0; index < labels.length; index++)
          Expanded(child: _option(context, index)),
      ],
    ),
  );

  Widget _option(BuildContext context, int index) => TextButton(
    onPressed: () => onSelected(index),
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(WidgetTokens.segmentInset),
      minimumSize: const Size.fromHeight(Tokens.minTouchTarget),
    ),
    child: Semantics(
      selected: selected == index,
      inMutuallyExclusiveGroup: true,
      child: _label(AppColors.of(context), index),
    ),
  );

  Widget _label(AppColors colors, int index) => Container(
    alignment: Alignment.center,
    constraints: const BoxConstraints(minHeight: WidgetTokens.segmentHeight),
    padding: const EdgeInsets.symmetric(horizontal: Tokens.space8),
    decoration: ShapeDecoration(
      shape: Tokens.chipShape,
      color: selected == index ? colors.text : colors.soft,
    ),
    child: Text(
      labels[index],
      textAlign: TextAlign.center,
      style: WidgetTokens.chipLabel.copyWith(
        color: selected == index ? colors.surface : colors.muted,
      ),
    ),
  );
}
