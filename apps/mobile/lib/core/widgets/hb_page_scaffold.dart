import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

class HbPageScaffold extends StatelessWidget {
  const HbPageScaffold({
    super.key,
    required this.topBar,
    required this.content,
    required this.actions,
    this.gap = Tokens.space20,
    this.footnote,
  });
  final Widget topBar;
  final List<Widget> content;
  final List<Widget> actions;
  final double gap;
  final Widget? footnote;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Tokens.screenMargin,
          Tokens.space16,
          Tokens.screenMargin,
          ContractTokens.pageBottom,
        ),
        child: LayoutBuilder(builder: _scroll),
      ),
    ),
  );

  Widget _scroll(BuildContext context, BoxConstraints constraints) =>
      SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(child: _content()),
        ),
      );

  Widget _content() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      topBar,
      const SizedBox(height: Tokens.space24),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: gap,
        children: content,
      ),
      const SizedBox(height: Tokens.space24),
      const Spacer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Tokens.space12,
        children: actions,
      ),
      if (footnote != null) ...[
        const SizedBox(height: Tokens.space12),
        ?footnote,
      ],
    ],
  );
}
