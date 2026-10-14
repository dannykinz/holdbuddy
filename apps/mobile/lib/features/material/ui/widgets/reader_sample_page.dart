import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../domain/reader_page.dart';

class ReaderSamplePage extends StatelessWidget {
  const ReaderSamplePage({super.key, required this.page});
  final ReaderPage page;
  @override
  Widget build(BuildContext context) => Card.outlined(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MaterialTokens.readerRadius),
      side: BorderSide(color: AppColors.of(context).line),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.space24,
        vertical: MaterialTokens.readerInset,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: Tokens.space12,
        children: [
          Text(
            page.section,
            style: MaterialTokens.section.copyWith(
              color: AppColors.of(context).subtle,
            ),
          ),
          Text(page.title, style: MaterialTokens.readerTitle),
          SelectableText(page.body, style: MaterialTokens.readerBody),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: MaterialTokens.highlightInset,
              vertical: WidgetTokens.segmentInset,
            ),
            decoration: BoxDecoration(
              color: AppColors.of(context).purpleSoft,
              borderRadius: BorderRadius.circular(
                MaterialTokens.highlightRadius,
              ),
            ),
            child: SelectableText(
              page.highlight,
              style: MaterialTokens.highlightBody,
            ),
          ),
          SelectableText(page.footer, style: MaterialTokens.readerBody),
        ],
      ),
    ),
  );
}
