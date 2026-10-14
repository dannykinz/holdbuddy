import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

typedef ColorPair = ({Color strong, Color soft});

enum HbCategory {
  purple,
  orange,
  green,
  sky,
  pink;

  ColorPair colors(AppColors colors) => switch (this) {
    purple => (strong: colors.purple, soft: colors.purpleSoft),
    orange => (strong: colors.orange, soft: colors.orangeSoft),
    green => (strong: colors.green, soft: colors.greenSoft),
    sky => (strong: colors.sky, soft: colors.skySoft),
    pink => (strong: colors.pink, soft: colors.pinkSoft),
  };
}
