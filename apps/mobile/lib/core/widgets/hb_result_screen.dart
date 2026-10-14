import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import 'hb_heading.dart';
import 'hb_page_header.dart';
import 'hb_page_scaffold.dart';
import 'hb_preview_note.dart';

class HbResultScreen extends StatelessWidget {
  const HbResultScreen({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    this.leading,
    this.details = const [],
    this.showBack = true,
    this.preview = true,
  });
  final String title;
  final String body;
  final List<Widget> actions;
  final Widget? leading;
  final List<Widget> details;
  final bool showBack;
  final bool preview;
  @override
  Widget build(BuildContext context) => HbPageScaffold(
    topBar: showBack
        ? const HbPageHeader()
        : const SizedBox(height: Tokens.minTouchTarget),
    content: [
      if (leading != null)
        Align(alignment: Alignment.centerLeft, child: leading),
      HbHeading(title: title, description: body),
      ...details,
    ],
    actions: actions,
    footnote: preview ? const HbPreviewNote() : null,
  );
}
