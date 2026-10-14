import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

class HbTabScaffold extends StatelessWidget {
  const HbTabScaffold({
    super.key,
    required this.children,
    this.topBar,
    this.footer,
    this.contentSpacing = Tokens.space24,
  });
  final List<Widget> children;
  final Widget? topBar;
  final Widget? footer;
  final double contentSpacing;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              Tokens.screenMargin,
              Tokens.space16,
              Tokens.screenMargin,
              DailyTokens.tabBottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: contentSpacing,
              children: [
                topBar ?? const SizedBox(height: Tokens.minTouchTarget),
                ...children,
              ],
            ),
          ),
          if (footer != null)
            Positioned(
              left: Tokens.screenMargin,
              right: Tokens.screenMargin,
              bottom: DailyTokens.navClearance,
              child: footer ?? const SizedBox.shrink(),
            ),
        ],
      ),
    ),
  );
}
