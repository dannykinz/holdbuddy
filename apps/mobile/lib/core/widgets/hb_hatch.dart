import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

class HbHatch extends StatelessWidget {
  const HbHatch({
    super.key,
    required this.color,
    this.opacity = WidgetTokens.hatchOpacity,
    this.child,
  }) : assert(opacity >= 0 && opacity <= 1);

  final Color color;
  final double opacity;
  final Widget? child;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _HatchPainter(color.withValues(alpha: opacity)),
    child: child,
  );
}

class _HatchPainter extends CustomPainter {
  const _HatchPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = WidgetTokens.hatchStroke;
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    for (
      double x = 0;
      x <= size.width + size.height;
      x += WidgetTokens.hatchGap
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HatchPainter oldDelegate) =>
      color != oldDelegate.color;
}
