import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_category.dart';
import 'hb_icon_tile.dart';

class HbEmptyState extends StatelessWidget {
  const HbEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.asset,
    required this.category,
    this.detail,
    this.action,
  });
  final String title;
  final String description;
  final String asset;
  final HbCategory category;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Tokens.space20,
    children: [
      HbIconTile(asset: asset, category: category, hero: true),
      _heading(context),
      if (detail case final detail?)
        Text(
          detail,
          style: Tokens.body.copyWith(color: AppColors.of(context).muted),
        ),
      if (action case final action?) action,
    ],
  );

  Widget _heading(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Tokens.space12,
    children: [
      Semantics(
        header: true,
        child: Text(
          title,
          style: Tokens.headline.copyWith(color: AppColors.of(context).text),
        ),
      ),
      Text(
        description,
        style: Tokens.body.copyWith(color: AppColors.of(context).muted),
      ),
    ],
  );
}
