import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

class HbSectionHeading extends StatelessWidget {
  const HbSectionHeading({
    super.key,
    required this.title,
    required this.action,
    required this.onPressed,
  });
  final String title;
  final String action;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(title, style: Tokens.strong)),
      TextButton(onPressed: onPressed, child: Text(action)),
    ],
  );
}
