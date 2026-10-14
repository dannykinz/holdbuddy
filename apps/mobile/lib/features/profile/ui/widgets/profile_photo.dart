import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_avatar.dart';
import '../../../../core/widgets/hb_sheet.dart';
import 'profile_photo_sheet.dart';

class ProfilePhoto extends StatelessWidget {
  const ProfilePhoto({
    super.key,
    required this.avatar,
    required this.name,
    required this.onChanged,
  });
  final String avatar;
  final String name;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            HbAvatar(
              image: AssetImage(avatar),
              label: name,
              size: PeopleTokens.profileAvatar,
            ),
            IconButton(
              tooltip: l.profilePhoto,
              onPressed: () => _choose(context),
              icon: _camera(context),
            ),
          ],
        ),
        TextButton(
          onPressed: () => _choose(context),
          child: Text(l.profilePhoto),
        ),
      ],
    );
  }

  Future<void> _choose(BuildContext context) async {
    final photo = await HbSheet.show<String>(
      context: context,
      title: AppLocalizations.of(context).profilePhoto,
      child: const ProfilePhotoSheet(),
    );
    if (context.mounted && photo != null) onChanged(photo);
  }

  Widget _camera(BuildContext context) => Container(
    width: PeopleTokens.cameraFace,
    height: PeopleTokens.cameraFace,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.of(context).primary,
      shape: BoxShape.circle,
      border: Border.all(
        color: AppColors.of(context).surface,
        width: PeopleTokens.cameraBorder,
      ),
    ),
    child: SvgPicture.asset(
      'assets/icons/people_camera.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).onPrimary,
        BlendMode.srcIn,
      ),
    ),
  );
}
