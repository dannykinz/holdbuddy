import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbInfoList extends StatelessWidget {
  const HbInfoList({
    super.key,
    required this.items,
    this.destructive = false,
    this.checked = false,
    this.soft = false,
  });
  final List<String> items;
  final bool destructive;
  final bool checked;
  final bool soft;
  @override
  Widget build(BuildContext context) => Card.outlined(
    color: soft ? AppColors.of(context).soft : AppColors.of(context).surface,
    child: Padding(
      padding: const EdgeInsets.all(Tokens.space16),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) const Divider(height: Tokens.space24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Tokens.space12,
              children: [
                Icon(
                  checked ? Icons.check_rounded : Icons.circle,
                  size: checked ? Tokens.space16 : Tokens.space8,
                  color: destructive
                      ? AppColors.of(context).error
                      : checked
                      ? AppColors.of(context).green
                      : AppColors.of(context).subtle,
                ),
                Expanded(child: Text(items[index], style: Tokens.small)),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}
