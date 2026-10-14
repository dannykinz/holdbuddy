import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import 'hb_avatar.dart';

class HbAvatarStack extends StatelessWidget {
  HbAvatarStack({super.key, required List<HbAvatar> avatars})
    : avatars = List.unmodifiable(avatars) {
    if (avatars.isEmpty || avatars.length > WidgetTokens.avatarStackCount) {
      throw ArgumentError('Avatar stacks require one to three faces.');
    }
  }
  final List<HbAvatar> avatars;

  @override
  Widget build(BuildContext context) => SizedBox(
    width:
        WidgetTokens.avatarSize +
        (avatars.length - 1) * WidgetTokens.avatarOverlap,
    height: WidgetTokens.avatarSize,
    child: Stack(
      children: [
        for (var index = 0; index < avatars.length; index++)
          Positioned(
            left: index * WidgetTokens.avatarOverlap,
            child: avatars[index],
          ),
      ],
    ),
  );
}
